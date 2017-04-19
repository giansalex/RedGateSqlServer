SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
cREATE procedure [dbo].[Vta_OrdPedidoDetCrea_7]
@RucE nvarchar(11),
@Cd_OP char(10),
@Item int,
@Cd_Prod char(7),
@Cd_Srv char(7), 
@Descrip varchar(200),
@ID_UMP int,
@PU numeric (18,9),
@Cant numeric(18,9),
@Valor numeric(18,9),
@DsctoP numeric(5,2),
@DsctoI numeric(18,9),
@BIM numeric(18,9),
@IGV numeric(18,9),
@Total numeric(18,9),
@PendEnt numeric(18,9),
@Cd_Alm varchar(20),
@Obs varchar(300),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@CA06 varchar(8000),
@CA07 varchar(8000),
@CA08 varchar(8000),
@CA09 varchar(8000),
@CA10 varchar(8000),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output,
@ValVtaUnit numeric(18,7),
@TotalVtaSD numeric(20,7),
@PrecioUnitSD numeric(18,7)
as

if exists(select * from OrdPedidoDet where RucE=@RucE and Item=@Item  and Cd_OP=@Cd_OP)
	Set @msj = 'Ya existe numero de detalle de orden de Pedido'
else
begin
	Set @Item = dbo.ItemOPD(@RucE,@Cd_OP)
	
	insert into OrdPedidoDet(RucE,Cd_OP,Item,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Cant,Valor,DsctoP,DsctoI,
					BIM,IGV,Total,PendEnt,Cd_Alm,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_CC,Cd_SC,Cd_SS,ValVtaUnit,TotalVtaSD,PrecioUnitSD)
				values(@RucE,@Cd_OP,@Item,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Cant,@Valor,@DsctoP,@DsctoI,
					@BIM,@IGV,@Total,@PendEnt,@Cd_Alm,@Obs,@FecMdf,@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_CC,@Cd_SC,@Cd_SS,@ValVtaUnit,@TotalVtaSD,@PrecioUnitSD)
	
	if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod))
		begin
			if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod and TieneFechaVigencia=1))
				begin
					if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod and @FecMdf BETWEEN FechaVigenciaInicio AND FechaVigenciaFin))
						update OrdPedido set IB_Percepcion = 1 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_OP=@Cd_OP
					else
						update OrdPedido set IB_Percepcion = 0 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_OP=@Cd_OP
				end
			else
				begin
					update OrdPedido set IB_Percepcion = 1 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_OP=@Cd_OP
				end
		end
	else
		begin
				update OrdPedido set IB_Percepcion = 0 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_OP=@Cd_OP
		end
	
	
	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle orden de pedido'
end
-- Leyenda --
-- JU : 2010-08-09 : <Creacion del procedimiento almacenado>
GO

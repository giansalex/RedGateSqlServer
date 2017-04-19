SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedidoDetCrea_2]
@RucE nvarchar(11),
@Cd_OP char(10),
@Item int,
@Cd_Prod char(7),
@Cd_Srv char(7), 
@Descrip varchar(200),
@ID_UMP int,
@PU numeric (13,4),
@Cant numeric(13,4),
@Valor numeric(13,4),
@DsctoP numeric(5,2),
@DsctoI numeric(13,4),
@BIM numeric(13,4),
@IGV numeric(13,4),
@Total numeric(13,4),
@PendEnt numeric(13,4),
@Cd_Alm varchar(20),
@Obs varchar(300),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 nvarchar(100),
@CA02 nvarchar(100),
@CA03 nvarchar(100),
@CA04 nvarchar(100),
@CA05 nvarchar(100),
@msj varchar(100) output
as

if exists(select * from OrdPedidoDet where RucE=@RucE and Item=@Item  and Cd_OP=@Cd_OP)
	Set @msj = 'Ya existe numero de detalle de orden de Pedido'
else
begin
	Set @Item = dbo.ItemOPD(@RucE,@Cd_OP)
	insert into OrdPedidoDet(RucE,Cd_OP,Item,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Cant,Valor,DsctoP,DsctoI,
				BIM,IGV,Total,PendEnt,Cd_Alm,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05)
			values(@RucE,@Cd_OP,@Item,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Cant,@Valor,@DsctoP,@DsctoI,
				@BIM,@IGV,@Total,@PendEnt,@Cd_Alm,@Obs,@FecMdf,@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05)
	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle orden de pedido'
end
-- Leyenda --
-- JU : 2010-08-09 : <Creacion del procedimiento almacenado>
GO

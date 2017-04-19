SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetCrea4]  /*CREADO 03/03/2015 - ADAPTADO PV*/

@RucE nvarchar(11),
@ID_CtD int output,
@Cd_Cot char(10),
@Cd_Prod char(7),
@Cd_Srv char(7),
@Descrip varchar(200),
@ID_UMP int,
@ID_Prec int,
@ID_PrSv int,
@CU numeric(18, 7),
@Costo numeric(18, 7),
@PU numeric(18, 7),
@Cant numeric(18, 7),
@Valor numeric(18, 7),
@DsctoP numeric(5, 2),
@DsctoI numeric(18, 7),
@BIM numeric(18, 7),
@IGV numeric(18, 7),
@Total numeric(18, 7),
@MU_Porc numeric(13, 2),
@MU_Imp numeric(18, 7),
@Obs varchar(200),

@FecMdf	datetime,
@UsuMdf	nvarchar(10),

@Cd_CC nvarchar(16),
@Cd_SC nvarchar(16),
@Cd_SS nvarchar(16),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

@msj varchar(100) output

as

if exists (select * from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=user123.IDx_CtD(@RucE,@Cd_Cot))
	Set @msj = 'Ya existe el id de detalle de cotizacion'
else
begin
	Set @ID_CtD = user123.IDx_CtD(@RucE,@Cd_Cot) -- DEVOLVIENDO EL ID DEL DETALLE DE LA COTIZACION
	insert into CotizacionDet(RucE,ID_CtD,Cd_Cot,Cd_Prod,Cd_Srv,Descrip,ID_UMP,ID_Prec,ID_PrSv,CU,Costo,PU,Cant,Valor,DsctoP,
			       	  DsctoI,BIM,IGV,Total,MU_Porc,MU_Imp,Obs,Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05)
			   Values(@RucE,user123.IDx_CtD(@RucE,@Cd_Cot),@Cd_Cot,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@ID_Prec,@ID_PrSv,@CU,@Costo,@PU,@Cant,@Valor,@DsctoP,
			       	  @DsctoI,@BIM,@IGV,@Total,@MU_Porc,@MU_Imp,@Obs,@Cd_CC,@Cd_SC,@Cd_SS,@CA01,@CA02,@CA03,@CA04,@CA05)


	if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod))
		begin
			if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod and TieneFechaVigencia=1))
				begin
					if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod and @FecMdf BETWEEN FechaVigenciaInicio AND FechaVigenciaFin))
						update Cotizacion set IB_Percepcion = 1 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_Cot=@Cd_Cot
					else
						update Cotizacion set IB_Percepcion = 0 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_Cot=@Cd_Cot
				end
			else
				begin
					update Cotizacion set IB_Percepcion = 1 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_Cot=@Cd_Cot
				end
		end
	else
		begin
				update Cotizacion set IB_Percepcion = 0 , FecMdf = @FecMdf , UsuMdf = @UsuMdf where RucE=@RucE and Cd_Cot=@Cd_Cot
		end
		

	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle de cotizacion'

	/************************************************/

end
GO

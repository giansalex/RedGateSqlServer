SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetCrea2]

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
--@FecMdf	datetime,
--@UsuMdf	nvarchar(10),

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
	Print 'RucE : ' + Convert(varchar,@RucE)
	Print 'IDx_CtD : ' + Convert(varchar,user123.IDx_CtD(@RucE,@Cd_Cot))
	Print 'Cd_Cot : ' + Convert(varchar,@Cd_Cot)
	Print 'Cd_Prod : ' + Convert(varchar,@Cd_Prod)
	Print 'Cd_Srv : ' + Convert(varchar,@Cd_Srv)
	Print 'Descrip : ' + Convert(varchar,@Descrip)
	Print 'ID_UMP : ' + Convert(varchar,@ID_UMP)
	Print 'ID_Prec : ' + Convert(varchar,@ID_Prec)
	Print 'ID_PrSv : ' + Convert(varchar,@ID_PrSv)
	Print 'CU : ' + Convert(varchar,@CU)
	Print 'Costo : ' + Convert(varchar,@Costo)
	Print 'PU : ' + Convert(varchar,@PU)
	Print 'Cant : ' + Convert(varchar,@Cant)
	Print 'Valor : ' + Convert(varchar,@Valor)
	Print 'DsctoP : ' + Convert(varchar,@DsctoP)
	Print 'DsctoI : ' + Convert(varchar,@DsctoI)
	Print 'BIM : ' + Convert(varchar,@BIM)
	Print 'IGV : ' + Convert(varchar,@IGV)
	Print 'Total : ' + Convert(varchar,@Total)
	Print 'MU_Porc : ' + Convert(varchar,@MU_Porc)
	Print 'MU_Imp : ' + Convert(varchar,@MU_Imp)
	Print 'Obs : ' + Convert(varchar,@Obs)
	
	Print 'Cd_CC : ' + Convert(varchar,@Cd_CC)
	Print 'Cd_SC : ' + Convert(varchar,@Cd_SC)
	Print 'Cd_SS : ' + Convert(varchar,@Cd_SS)
	Print 'CA01 : ' + Convert(varchar,@CA01)
	Print 'CA02 : ' + Convert(varchar,@CA02)
	Print 'CA03 : ' + Convert(varchar,@CA03)
	Print 'CA04 : ' + Convert(varchar,@CA04)
	Print 'CA05 : ' + Convert(varchar,@CA05)
	


	Set @ID_CtD = user123.IDx_CtD(@RucE,@Cd_Cot) -- DEVOLVIENDO EL ID DEL DETALLE DE LA COTIZACION
	insert into CotizacionDet(RucE,ID_CtD,Cd_Cot,Cd_Prod,Cd_Srv,Descrip,ID_UMP,ID_Prec,ID_PrSv,CU,Costo,PU,Cant,Valor,DsctoP,
			       	  DsctoI,BIM,IGV,Total,MU_Porc,MU_Imp,Obs,Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05)
			   Values(@RucE,user123.IDx_CtD(@RucE,@Cd_Cot),@Cd_Cot,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@ID_Prec,@ID_PrSv,@CU,@Costo,@PU,@Cant,@Valor,@DsctoP,
			       	  @DsctoI,@BIM,@IGV,@Total,@MU_Porc,@MU_Imp,@Obs,@Cd_CC,@Cd_SC,@Cd_SS,@CA01,@CA02,@CA03,@CA04,@CA05)

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al registrar detalle de cotizacion'
		return
	end


	/************************************************/

end
print @msj
-- Leyedan --
-- DI : 09/06/2011 : <Creacion del procedimiento almacenado>
-- KJ : 16/11/2012 : <Agregó a 7 los decimales>
GO

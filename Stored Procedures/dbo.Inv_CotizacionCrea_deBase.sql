SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionCrea_deBase]

--exec Inv_CotizacionCrea_deBase '11111111111',null,'NRO-00000000002','CT00000001','Diego',null

@RucE nvarchar(11),
@Cd_Cot char(10) output,
@NroCot varchar(15),
@CdCot_Base char(10),
@ConBase bit,
@UsuCrea nvarchar(10),
@msj varchar(100) output

as

begin
	Set @Cd_Cot = user123.Cod_Cot(@RucE) --Obteniendo el codigo de cotizacion
	

	/* COPIANDO COTIZACION */

	insert into Cotizacion(RucE,Cd_Cot,NroCot,FecEmi,FecCad,Cd_FPC,Asunto,Cd_Clt,Cd_Vdr,
			       CostoTot,Valor,TotDsctoP,TotDsctoI,INF,DsctoFnzInf_P,DsctoFnzInf_I,INF_Neto,BIM,
			       DsctoFnzAf_P,DsctoFnzAf_I,BIM_Neto,IGV,Total,
			       MU_Porc,MU_Imp,Cd_Mda,CamMda,Cd_Area,Obs,FecReg,UsuCrea,CdCot_Base,
			       Id_EstC,Cd_FCt,CA01,CA02,CA03,CA04,CA05)
	select @RucE,@Cd_Cot,@NroCot,
	       FecEmi,FecCad,Cd_FPC,Asunto,Cd_Clt,Cd_Vdr,CostoTot,Valor,TotDsctoP,TotDsctoI,INF,DsctoFnzInf_P,DsctoFnzInf_I,INF_Neto,
	       BIM,DsctoFnzAf_P,DsctoFnzAf_I,BIM_Neto,IGV,Total,MU_Porc,MU_Imp,Cd_Mda,CamMda,Cd_Area,Obs,getdate(),
	       @UsuCrea,case(@ConBase) when 1 then @CdCot_Base else NULL end as CdCot_Base,
	       '01',Cd_FCt,CA01,CA02,CA03,CA04,CA05
	from Cotizacion where RucE=@RucE and Cd_Cot=@CdCot_Base

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al copiar cotizacion'
		return
	end
	

	/* COPIANDO DETALLE DE COTIZACION */

	insert into CotizacionDet(RucE,Cd_Cot,ID_CtD,Cd_Prod,Cd_Srv,Descrip,ID_UMP,ID_Prec,ID_PrSv,CU,Costo,PU,Cant,Valor,DsctoP,
		       	  DsctoI,BIM,IGV,Total,MU_Porc,MU_Imp,Obs)
	select  @RucE,@Cd_Cot,ID_CtD,
		Cd_Prod,Cd_Srv,Descrip,ID_UMP,ID_Prec,ID_PrSv,CU,Costo,PU,Cant,Valor,DsctoP,DsctoI,BIM,IGV,Total,MU_Porc,MU_Imp,Obs
	from CotizacionDet where RucE=@RucE and Cd_Cot=@CdCot_Base

	if @@rowcount <  0
	begin
		Set @msj = 'Error al copiar detalle de cotizacion'
		return
	end

	/* COPIANDO DETALLE DE LOS PRODUCTOS DE COTIZACION */

	insert into CotizacionProdDet(RucE,Cd_Cot,ID_CtD,Item,Cpto,Valor)
	select @RucE,@Cd_Cot,ID_CtD,
	       Item,Cpto,Valor
	from CotizacionProdDet where RucE=@RucE and Cd_Cot=@CdCot_Base
	
	if @@rowcount < 0
	begin
		Set @msj = 'Error al copiar detalle de producto de cotizacion'
	end
end

-- Leyedan --
-- DI : 26/04/2010 : <Creacion del procedimiento almacenado>
GO

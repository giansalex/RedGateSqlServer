SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetMdf]

@RucE nvarchar(11),
@ID_CtD int,
@Cd_Cot char(10),
--@Cd_Prod char(7),
--@Cd_Srv char(7),
@Descrip varchar(200),
--@ID_UMP int,
--@ID_Prec int,
@CU numeric(13, 2),
@Costo numeric(13, 2),
@PU numeric(13, 2),
@Cant numeric(13, 3),
@Valor numeric(13, 2),
@DsctoP numeric(5, 2),
@DsctoI numeric(13, 2),
@BIM numeric(13, 2),
@IGV numeric(13, 2),
@Total numeric(13, 2),
@MU_Porc numeric(13, 2),
@MU_Imp numeric(13, 2),
@Obs varchar(200),
--@FecMdf	datetime,
@UsuMdf	nvarchar(10),

/*VALORES RETORNADOS*/
--*************************

@NetTot_ decimal(13,2) output,
@CosTot_ decimal(13,2) output,
@UtiTotI_ decimal(13,2) output,
@UtiTotP_ decimal(5,2) output,
@InfImp_ decimal(13,2) output,
@BimImp_ decimal(13,2) output,
@DsctoFnzInf_P decimal(5,2) ,
@DsctoFnzInf_I decimal(13,2) ,
@DsctoFnzAf_P decimal(5,2) ,
@DsctoFnzAf_I decimal(13,2) ,
@InfTot_ decimal(13,2) output,
@BimTot_ decimal(13,2) output,
@IgvTot_ decimal(13,2) output,
@GenTot_ decimal(13,2) output,

@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),

--*************************

@msj varchar(100) output

as

if not exists (select * from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD)
	Set @msj = 'No existe detalle de cotizacion'
else
begin
	update CotizacionDet set
				--Cd_Prod=@Cd_Prod,
				--Cd_Srv=@Cd_Srv,
				Descrip=@Descrip,
				CU=@CU,
				Costo=@Costo,
				PU=@PU,
				Cant=@Cant,
				Valor=@Valor,
				DsctoP=@DsctoP,
				DsctoI=@DsctoI,
				BIM=@BIM,
				IGV=@IGV,
				Total=@Total,
				MU_Porc=@MU_Porc,
				MU_Imp=@MU_Imp,
				Obs=@Obs,
				FecMdf=getdate(),
				UsuMdf=@UsuMdf,
				Cd_CC = @Cd_CC,
				Cd_SC = @Cd_SC,
				Cd_SS = @Cd_SS
	where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD 
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al modificar detalle de cotizacion'
		return
	end


	/*OBTENIENDO LOS TOTALES GENERALES DE COTIZACION*/
	/************************************************/

	--Obteniendo informacion para Cotizacion de la tabla CotizacionDet
	Declare @ValVta_ decimal(13,2),@TotDscP_ decimal(5,2),@TotDscI_ decimal(13,2)
	select 
		@CosTot_  = Sum(isnull(Costo,0)),
		@ValVta_ = Sum(isnull(Valor,0)),
		@TotDscP_ = Sum(isnull(DsctoP,0)),
		@TotDscI_ = Sum(isnull(DsctoI,0)),

		@InfImp_ = Sum(Case(isnull(IGV,0)) when 0 then BIM else 0 end),
		@BimImp_ = Sum(Case(isnull(IGV,0)) when 0 then 0 else BIM end),
		@InfTot_ = @InfImp_ - @DsctoFnzInf_I,
		@BimTot_ = @BimImp_ - @DsctoFnzAf_I,
		@IgvTot_ = @BimTot_ * (user123.IGV()/100),
		@GenTot_ = @InfTot_ + @BimTot_ + @IgvTot_,

		@NetTot_ =  @InfTot_ + @BimTot_,
		@UtiTotI_ = @NetTot_ - @CosTot_,
		@UtiTotP_ = (@UtiTotI_ * 100)/@CosTot_--@NetTot_

	from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot

	--Actualizando informacion para cotizacion
	Update Cotizacion Set
		CostoTot = @CosTot_,
		Valor = @ValVta_,
		TotDsctoI = @TotDscI_,
		TotDsctoP = @TotDscP_,

		DsctoFnzInf_P = @DsctoFnzInf_P,
		DsctoFnzInf_I = @DsctoFnzInf_I,
		DsctoFnzAf_P = @DsctoFnzAf_P,
		DsctoFnzAf_I = @DsctoFnzAf_I,

		MU_Imp = @UtiTotI_,
		MU_Porc = @UtiTotP_,
		INF = @InfImp_,
		BIM = @BimImp_,
		INF_Neto = @InfTot_,
		BIM_Neto = @BimTot_,
		IGV = @IgvTot_,
		Total = @GenTot_

	where RucE=@RucE and Cd_Cot=@Cd_Cot

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al calcular los totales de Cotizacion'
	end

	/************************************************/
end
print @msj
-- Leyedan --
-- DI : 22/03/2010 : <Creacion del procedimiento almacenado>
-- DI : 12/04/2010 : <Se grego codigo para el retorno y modificacion de los valores de cotizacion>
-- DI : 14/04/2010 : <Se grego campo inafecto en tabla cotizacion>
GO

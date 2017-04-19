SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetElim]
@RucE nvarchar(11),
@Cd_Cot char(10),
@Cadena varchar(100),


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

--*************************

@msj varchar(100) output


as

begin
begin transaction

	exec ('delete from CotizacionProdDet where RucE='''+@RucE+''' and Cd_Cot='''+@Cd_Cot+''' and ID_CtD in ('+@Cadena+')')

	exec ('delete from CotizacionDet where RucE='''+@RucE+''' and Cd_Cot='''+@Cd_Cot+''' and ID_CtD in ('+@Cadena+')')
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al eliminar detalle de cotizacion'
		rollback transaction
		return
	end

	

	/*OBTENIENDO LOS TOTALES GENERALES DE COTIZACION*/
	/************************************************/

	--Obteniendo informacion para Cotizacion de la tabla CotizacionDet
	Declare @ValVta_ decimal(13,2),@TotDscP_ decimal(5,2),@TotDscI_ decimal(13,2)
	select 
		/*
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
		*/
		@CosTot_  = Sum(isnull(Costo,0)),
		@ValVta_ = Sum(isnull(Valor,0)),
		@TotDscP_ = Sum(isnull(DsctoP,0)),
		@TotDscI_ = Sum(isnull(DsctoI,0)),

		@InfImp_ = Sum(Case(isnull(IGV,0)) when 0 then BIM else 0 end),
		@BimImp_ = Sum(Case(isnull(IGV,0)) when 0 then 0 else BIM end),
		@InfTot_ = isnull(@InfImp_,0) - @DsctoFnzInf_I,
		@BimTot_ = isnull(@BimImp_,0) - @DsctoFnzAf_I,
		@IgvTot_ = isnull(@BimTot_,0) * (user123.IGV()/100),
		@GenTot_ = isnull(@InfTot_,0) + isnull(@BimTot_,0) + isnull(@IgvTot_,0),
		@NetTot_ =  isnull(@InfTot_,0) + isnull(@BimTot_,0),
		@UtiTotI_ = isnull(@NetTot_,0) - isnull(@CosTot_,0),
		@UtiTotP_ = ((@UtiTotI_ * 100)/@CosTot_)
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

commit transaction
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
-- DI : 14/04/2010 : <Se grego campo inafecto en tabla cotizacion>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetCrea]

/*
Declare @msj varchar(100)
exec Inv_CotizacionDetCrea '11111111111','CT00000002',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,@msj output
print @msj

*/

@RucE nvarchar(11),
--@ID_CtD int,
@Cd_Cot char(10),
@Cd_Prod char(7),
@Cd_Srv char(7),
@Descrip varchar(200),
@ID_UMP int,
@ID_Prec int,
@ID_PrSv int,
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
--@UsuMdf	nvarchar(10),

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

	insert into CotizacionDet(RucE,ID_CtD,Cd_Cot,Cd_Prod,Cd_Srv,Descrip,ID_UMP,ID_Prec,ID_PrSv,CU,Costo,PU,Cant,Valor,DsctoP,
			       	  DsctoI,BIM,IGV,Total,MU_Porc,MU_Imp,Obs)
			   Values(@RucE,user123.IDx_CtD(@RucE,@Cd_Cot),@Cd_Cot,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@ID_Prec,@ID_PrSv,@CU,@Costo,@PU,@Cant,@Valor,@DsctoP,
			       	  @DsctoI,@BIM,@IGV,@Total,@MU_Porc,@MU_Imp,@Obs)

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al registrar detalle de cotizacion'
		return
	end

	Print '--FIN ETAPA 1--'

	/*OBTENIENDO LOS TOTALES GENERALES DE COTIZACION*/
	/************************************************/


Print 'DsctoFnzInf_P : ' + Convert(varchar,@DsctoFnzInf_P)
Print 'DsctoFnzInf_I : ' + Convert(varchar,@DsctoFnzInf_I)
Print 'DsctoFnzAf_P : ' + Convert(varchar,@DsctoFnzAf_P)
Print 'DsctoFnzAf_I : ' + Convert(varchar,@DsctoFnzAf_I)
/*
Declare @NetTot_ decimal(13,2)
Declare @CosTot_ decimal(13,2) 
Declare @UtiTotI_ decimal(13,2) 
Declare @UtiTotP_ decimal(5,2) 
Declare @InfImp_ decimal(13,2) 
Declare @BimImp_ decimal(13,2) 
Declare @DsctoFnzInf_P decimal(5,2) 
Declare @DsctoFnzInf_I decimal(13,2) 
Declare @DsctoFnzAf_P decimal(5,2) 
Declare @DsctoFnzAf_I decimal(13,2) 
Declare @InfTot_ decimal(13,2) 
Declare @BimTot_ decimal(13,2) 
Declare @IgvTot_ decimal(13,2) 
Declare @GenTot_ decimal(13,2) 
Set @DsctoFnzInf_P = 0
Set @DsctoFnzInf_I = 0
Set @DsctoFnzAf_P = 0
Set @DsctoFnzAf_I = 0
*/

	--Obteniendo informacion para Cotizacion de la tabla CotizacionDet
	
	Declare @ValVta_ decimal(13,2),@TotDscP_ decimal(5,2),@TotDscI_ decimal(13,2)
	Set @ValVta_ = 0 Set @TotDscP_ = 0 Set @TotDscI_ = 0
	select 
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

	Print '--FIN ETAPA 2--'

	--Actualizando informacion para cotizacion
	--Select * from Cotizacion
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

	Print '--FIN ETAPA 3--'

	Print @RucE
	Print @Cd_Cot

	/************************************************/

end
print @msj
-- Leyedan --
-- DI : 04/03/2010 : <Creacion del procedimiento almacenado>
-- DI : 18/03/2010 : <Se modifico los campos, se agrego el campo Cd_Srv,CU..>
-- DI : 12/04/2010 : <Se grego codigo para el retorno y modificacion de los valores de cotizacion>
-- DI : 14/04/2010 : <Se grego campo inafecto en tabla cotizacion>
GO

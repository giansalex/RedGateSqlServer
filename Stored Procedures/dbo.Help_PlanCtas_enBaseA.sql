SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Help_PlanCtas_enBaseA]

@Ruc_Origen nvarchar(11),
@Ejer_Origen nvarchar(4),
@Ruc_Destin nvarchar(11),
@Ejer_Destin nvarchar(4)

AS

/*
Declare @Ruc_Origen nvarchar(11)
Declare @Ejer_Origen nvarchar(4)
Declare @Ruc_Destin nvarchar(11)
Declare @Ejer_Destin nvarchar(4)

Set @Ruc_Origen= '11111111111'
Set @Ejer_Origen= '2012'
Set @Ruc_Destin= '11111111111'
Set @Ejer_Destin= '2013'
*/

Declare @msj varchar(8000)
Set @msj = ''

if not exists (Select * From Empresa Where Ruc=@Ruc_Origen)
	Set @msj += char(13)+'* El ruc de origen '+@Ruc_Origen+' no existe'
if not exists (Select * From Empresa Where Ruc=@Ruc_Destin)
	Set @msj += char(13)+'* El ruc de destino '+@Ruc_Origen+' no existe'
	
if not exists (Select * From Periodo Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen)
	Set @msj += char(13)+'* El ejer de origen '+@Ejer_Origen+' no existe'
if not exists (Select * From Periodo Where RucE=@Ruc_Destin and Ejer=@Ejer_Destin)
	Set @msj += char(13)+'* El ejer de destino '+@Ejer_Destin+' no existe'
	
if not exists (Select * From PlanCtas Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen)
	Set @msj += char(13)+'* En el ejer '+@Ejer_Origen+' de la empresa origen '+@Ruc_Origen+' no tiene plan de cuentas <Tabla PlanCtas>' 
if exists (Select * From PlanCtas Where RucE=@Ruc_Destin and Ejer=@Ejer_Destin)
	Set @msj += char(13)+'* La empresa destino '+@Ruc_Destin+' ya contiene plan de cuentas en el ejer '+@Ejer_Destin + ' <Tabla PlanCtas>'

if not exists (Select * From PlanCtasDef Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen)
	Set @msj += char(13)+'* En el ejer '+@Ejer_Origen+' de la empresa origen '+@Ruc_Origen+' no tiene defincion de plan de cuentas <Tabla PlanCtasDef>' 
if exists (Select * From PlanCtasDef Where RucE=@Ruc_Destin and Ejer=@Ejer_Destin)
	Set @msj += char(13)+'* La empresa destino '+@Ruc_Destin+' ya contiene definicion plan de cuentas en el ejer '+@Ejer_Destin +' <Tabla PlanCtasDef>'

if not exists (Select * From AmarreCta Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen)
	Set @msj += char(13)+'* En el ejer '+@Ejer_Origen+' de la empresa origen '+@Ruc_Origen+' no tiene cuentas destinos <Tabla AmarreCta>' 
if exists (Select * From AmarreCta Where RucE=@Ruc_Destin and Ejer=@Ejer_Destin)
	Set @msj += char(13)+'* La empresa destino '+@Ruc_Destin+' ya contiene cuentas destinos en el ejer '+@Ejer_Destin +' <Tabla AmarreCta>'


if(@msj = '')
Begin
	-- Insertando el plan de cuentas
	
	insert into PlanCtas
	Select
		@Ruc_Destin As RucE,
		@Ejer_Destin As Ejer,
		NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,IB_PFC,IB_NDoc,IB_Prod,IB_Imp,IB_Dtr,IB_IGV,REF01,REF02,REF03,REF04,REF05,REF06,REF07,REF08,REF09,REF10,IB_MCC,IB_MCE
	From PlanCtas 
	Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen
	if @@rowcount < 0
		Set @msj += char(13)+'No se pudo insertar Plan de cuentas <Tabla PlanCtas>'
	else
		Set @msj += char(13)+'Se inserto correctamente Plan de cuentas <Tabla PlanCtas>'
	
	
	-- Insertando las definiciones de plan de cuentas
	Insert into PlanCtasDef
	Select 
		@Ruc_Destin As RucE,
		@Ejer_Destin As Ejer,
		IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls,CtaClt,CtaPrv,REjer
	From PlanCtasDef 
	Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen
	if @@rowcount < 0
		Set @msj += char(13)+'No se pudo insertar Definicion de Plan de cuentas <Tabla PlanCtasDef>'
	else
		Set @msj += char(13)+'Se inserto correctamente Definicion de Plan de cuentas <Tabla PlanCtasDef>'
		

	-- Insertando las los detinos de las cuentas
	Declare @UI int
	Set @UI = (Select Max(Item) From AmarreCta WHERE RucE=@Ruc_Origen)

	insert into AmarreCta
	Select
		ROW_NUMBER() OVER(PARTITION BY RucE ORDER BY Item ASC) + @UI AS Item,  
		@Ruc_Destin As RucE,
		@Ejer_Destin As Ejer,
		NroCta,CtaD,CtaH,Porc
	From AmarreCta 
	Where RucE=@Ruc_Origen and Ejer=@Ejer_Origen
	Order by Item
	if @@rowcount < 0
		Set @msj += char(13)+'No se pudo insertar Cuentas Destino <Tabla AmarreCta>'
	else
		Set @msj += char(13)+'Se inserto correctamente Cuentas Destino <Tabla AmarreCta>'
End

print @msj


-- Leyenda --
-- DI <22/01/2013> : Creacion del SP

GO

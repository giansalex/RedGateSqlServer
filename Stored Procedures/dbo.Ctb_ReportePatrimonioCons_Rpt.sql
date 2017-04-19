SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ctb_ReportePatrimonioCons_Rpt]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Cd_Mda nvarchar(2),
@N1 bit,
@N2 bit,
@N3 bit,
@N4 bit,

@msj varchar(100) output

AS

/*
DECLARE 
	@RucE nvarchar(11),
	@Ejer nvarchar(4),
	@PrdoD nvarchar(2),
	@PrdoH nvarchar(2),
	@Cd_Mda nvarchar(2),
	@N1 bit,
	@N2 bit,
	@N3 bit,
	@N4 bit

SET @RucE='11111111111'
SET @Ejer='2012'
SET @PrdoD='01'
SET @PrdoH='12'
SET @Cd_Mda='01'
SET @N1='1'
SET @N2='1'
SET @N3='0'
SET @N4='0'
*/


-- ********** COLUMNAS **********
Select 
	Cd_CPtr,
	Nombre,
	NCorto 
From 
	ReportePatrimonio
Where 
	RucE=@RucE
	and Ejer=@Ejer
	and isnull(Estado,0)=1
	

-- ********** DATOS **********
Select 
	Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End As Cd_CPtrD,
	Case When isnull(r.Nombre,'')<>'' Then r.Nombre Else isnull(p.NomCta,'') End As Nombre,
	r.NroCta,
	isnull(r.IB_esTitulo,0) As IB_esTitulo,
	isnull(r.Formula,'') As Formula,
	isnull(r.Cd_CPtr,'') As Cd_CPtr,
	Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End As Saldo
	,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End As EsInicial
From 
	ReportePatrimonioDet r
	Left Join Voucher v On v.RucE=r.RucE and v.Ejer=r.Ejer and v.Prdo <= @PrdoH and v.NroCta like r.NroCta+'%'
	Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
Where 
	r.RucE=@RucE
	and r.Ejer=@Ejer
	and isnull(r.Estado,0)=1
Group by
	Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End,
	Case When isnull(r.Nombre,'')<>'' Then r.Nombre Else isnull(p.NomCta,'') End,
	r.NroCta,isnull(r.IB_esTitulo,0),isnull(r.Formula,''),isnull(r.Cd_CPtr,'')
	,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End
Order by 8
	
	
-- ********** NIVEL 1 **********
IF (@N1=1)
BEGIN
	Select
		Res.Cd_CPtrD,p.NomCta As Nombre,Res.NroCta,Res.IB_esTitulo,Res.Formula,Res.Cd_CPtr,Res.Saldo,Res.EsInicial
	From
		(
			Select 
				r.RucE,
				r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End As Cd_CPtrD,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End As NroCta,
				isnull(r.IB_esTitulo,0) As IB_esTitulo,
				isnull(r.Formula,'') As Formula,
				isnull(r.Cd_CPtr,'') As Cd_CPtr,
				Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End As Saldo
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End As EsInicial
			From 
				ReportePatrimonioDet r
				Left Join Voucher v On v.RucE=r.RucE and v.Ejer=r.Ejer  and v.Prdo <= @PrdoH and v.NroCta like r.NroCta+'%'
			Where 
				r.RucE=@RucE
				and r.Ejer=@Ejer 
				and isnull(r.Estado,0)=1
			Group by
				r.RucE,
				r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End,
				isnull(r.IB_esTitulo,0),
				isnull(r.Formula,''),isnull(r.Cd_CPtr,'')
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End
			Having 
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End<>''
				and Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End <> 0
		) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Order by 8
END

-- ********** NIVEL 2 **********
IF (@N2=1)
BEGIN
	Select
		Res.Cd_CPtrD,p.NomCta As Nombre,Res.NroCta,Res.N1,Res.IB_esTitulo,Res.Formula,Res.Cd_CPtr,Res.Saldo,Res.EsInicial
	From
		(
			Select 
				r.RucE,r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End As Cd_CPtrD,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End As NroCta,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End As N1,
				isnull(r.IB_esTitulo,0) As IB_esTitulo,
				isnull(r.Formula,'') As Formula,
				isnull(r.Cd_CPtr,'') As Cd_CPtr,
				Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End As Saldo
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End As EsInicial
			From 
				ReportePatrimonioDet r
				Left Join Voucher v On v.RucE=r.RucE and v.Ejer=r.Ejer  and v.Prdo <= @PrdoH and v.NroCta like r.NroCta+'%'
			Where 
				r.RucE=@RucE
				and r.Ejer=@Ejer 
				and isnull(r.Estado,0)=1
			Group by
				r.RucE,
				r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End,
				isnull(r.IB_esTitulo,0),
				isnull(r.Formula,''),isnull(r.Cd_CPtr,'')
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End
			Having 
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End<>''
				and Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End <> 0
		) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Order by 8
END


-- ********** NIVEL 3 **********
IF (@N3=1)
BEGIN
	Select
		Res.Cd_CPtrD,p.NomCta As Nombre,Res.NroCta,Res.N1,Res.N2,Res.IB_esTitulo,Res.Formula,Res.Cd_CPtr,Res.Saldo,Res.EsInicial
	From
		(
			Select 
				r.RucE,r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End As Cd_CPtrD,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,6) Else '' End As NroCta,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End As N1,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End As N2,
				isnull(r.IB_esTitulo,0) As IB_esTitulo,
				isnull(r.Formula,'') As Formula,
				isnull(r.Cd_CPtr,'') As Cd_CPtr,
				Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End As Saldo
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End As EsInicial
			From 
				ReportePatrimonioDet r
				Left Join Voucher v On v.RucE=r.RucE and v.Ejer=r.Ejer  and v.Prdo <= @PrdoH and v.NroCta like r.NroCta+'%'
			Where 
				r.RucE=@RucE
				and r.Ejer=@Ejer 
				and isnull(r.Estado,0)=1
			Group by
				r.RucE,
				r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,6) Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End,
				isnull(r.IB_esTitulo,0),
				isnull(r.Formula,''),isnull(r.Cd_CPtr,'')
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End
			Having 
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,6) Else '' End<>''
				and Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End <> 0
		) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Order by 8
END
	
	
-- ********** NIVEL 4 **********
IF (@N4=1)
BEGIN
	Select
		Res.Cd_CPtrD,p.NomCta As Nombre,Res.NroCta,Res.N1,Res.N2,Res.N3,Res.IB_esTitulo,Res.Formula,Res.Cd_CPtr,Res.Saldo,Res.EsInicial
	From
		(
			Select 
				r.RucE,r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End As Cd_CPtrD,
				Case When isnull(v.NroCta,'')<>'' Then v.NroCta Else '' End As NroCta,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End As N1,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End As N2,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,6) Else '' End As N3,
				isnull(r.IB_esTitulo,0) As IB_esTitulo,
				isnull(r.Formula,'') As Formula,
				isnull(r.Cd_CPtr,'') As Cd_CPtr,
				Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End As Saldo
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End As EsInicial
			From 
				ReportePatrimonioDet r
				Left Join Voucher v On v.RucE=r.RucE and v.Ejer=r.Ejer  and v.Prdo <= @PrdoH and v.NroCta like r.NroCta+'%'
			Where 
				r.RucE=@RucE
				and r.Ejer=@Ejer 
				and isnull(r.Estado,0)=1
			Group by
				r.RucE,
				r.Ejer,
				Case When v.Prdo < @PrdoD Then '' Else r.Cd_CPtrD End,
				Case When isnull(v.NroCta,'')<>'' Then v.NroCta Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,2) Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,4) Else '' End,
				Case When isnull(v.NroCta,'')<>'' Then left(v.NroCta,6) Else '' End,
				isnull(r.IB_esTitulo,0),
				isnull(r.Formula,''),isnull(r.Cd_CPtr,'')
				,Case When v.Prdo < @PrdoD Then Convert(bit,'1') Else Convert(bit,'0') End
			Having 
				Case When isnull(v.NroCta,'')<>'' Then v.NroCta Else '' End<>''
				and Case When @Cd_Mda='01' Then isnull(Sum(v.MtoH-v.MtoD),0.00) Else isnull(Sum(v.MtoH_ME-v.MtoD_ME),0.00) End <> 0
		) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Order by 8
END


-- Leyenda --
-- DI : 04/01/2013 <Creacion del SP>


GO

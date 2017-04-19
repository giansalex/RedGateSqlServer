SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFCCons_Rpt]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Moneda nvarchar(1),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@NroCta varchar(12),

@msj varchar(100) output

AS
--************** INFORMACION PRESUPUESTADA **************--
--Select  'Psp' As Tipo,'00' Prdo, 0.00 As Monto UNION ALL  Select  'Eje' As Tipo,'00' Prdo, 0.00 As Monto

--UNION ALL

Select 
	'Psp' As Tipo, Prdo,Case When @Moneda='s' Then Sum(Mto) Else Sum(Mto_ME) End As Monto 
from 
	PresupFCTot 
Where 
	RucE=@RucE 
	and Ejer=@Ejer 
	and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End = isnull(@Cd_CC,'')
	and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End = isnull(@Cd_SC,'')
	and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End = isnull(@Cd_SS,'')
	and Case When isnull(@NroCta,'')='' Then '' Else NroCta End = isnull(@NroCta,'')
	and Prdo between @PrdoD and @PrdoH 
Group by Prdo


UNION ALL

--************** INFORMACION EJECUTADA **************--
Select 
	'Eje' As Tipo,Prdo,Case When @Moneda='s' Then Sum(MtoD-MtoH) Else Sum(MtoD_ME-MtoH_ME) End As Monto 
from 
	Voucher 
Where 
	RucE=@RucE 
	and Ejer=@Ejer 
	and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End = isnull(@Cd_CC,'')
	and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End = isnull(@Cd_SC,'')
	and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End = isnull(@Cd_SS,'')
	and Case When isnull(@NroCta,'')='' Then '' Else NroCta End = isnull(@NroCta,'')
	and Prdo between @PrdoD and @PrdoH
      	and NroCta in (	Select NroCta 
			from PresupFC
			Where 	RucE=@RucE 
				and Ejer=@Ejer 
				and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End = isnull(@Cd_CC,'')
				and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End = isnull(@Cd_SC,'')
				and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End = isnull(@Cd_SS,'')
				and Case When isnull(@NroCta,'')='' Then '' Else NroCta End = isnull(@NroCta,'')
			Group By NroCta
		       ) Group by Prdo


-- Leyenda --
-- DI : 05/01/2011 <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ges_CantidadRegistro_X_Usuario]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Usuarios nvarchar(4000),
@Tipo char(1),

@msj varchar(100) output

AS

/*
DECLARE @RucE nvarchar(11)
DECLARE @Ejer nvarchar(4)
DECLARE @PrdoD nvarchar(2)
DECLARE @PrdoH nvarchar(2)
DECLARE @Usuarios nvarchar(4000)

DECLARE @Tipo char(1)

SET @RucE='11111111111'
SET @Ejer='2011'
SET @PrdoD='00'
SET @PrdoH='05'
SET @Usuarios='''caliaga'''
SET @Tipo='m'
*/

DECLARE @CONDICION varchar(8000)
SET @CONDICION=''
IF(len(ltrim(@Usuarios)) > 0)
BEGIN
	SET @CONDICION=' and v.UsuCrea in ('+@Usuarios+')'
END


DECLARE @SQL1 varchar(8000)
DECLARE @SQL2 varchar(1000)

DECLARE @SQL3 varchar(8000)
DECLARE @SQL4 varchar(8000)

SET @SQL1=
'
SELECT
	v.Prdo,
	v.UsuCrea As NomUsu,
	u.NomComp As Empleado,
	Sum(Case When v.Cd_Fte=''RV'' Then 1 Else 0 End) As RV,
	0.000 As TRV,
	Sum(Case When v.Cd_Fte=''RC'' Then 1 Else 0 End) As RC,
	0.000 As TRC,
	Sum(Case When v.Cd_Fte=''CB'' Then 1 Else 0 End) As CB,
	0.000 As TCB,
	Sum(Case When v.Cd_Fte=''LD'' Then 1 Else 0 End) As LD,
	0.000 As TLD,
	0.00 AS Total,
	0.000 As TTotal
FROM
	Voucher v
	LEFT JOIN Usuario u ON u.NomUsu=v.UsuCrea
WHERE
	v.RucE='''+@RucE+'''
	and v.Ejer='''+@Ejer+'''
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
'	
SET @SQL2=
'
GROUP BY 
	v.Prdo,v.UsuCrea,u.NomComp
ORDER by
	v.Prdo
'

SET @SQL3=
'
SELECT 
	TAB.Prdo,TAB.Cd_Fte,
	CASE ('''+@Tipo+''') WHEN ''h'' THEN Sum(TAB.HH)+(Sum(TAB.MM)/60.00)+(Sum(TAB.SS)/3600.00)+((Sum(TAB.MS)/(3600*1000.00)))
			     WHEN ''m'' THEN Sum(TAB.HH*60)+Sum(TAB.MM)+(Sum(TAB.SS)/60.00)+((Sum(TAB.MS)/(60.00*1000.00)))
			     WHEN ''s'' THEN Sum(TAB.HH*3600)+Sum(TAB.MM*60)+(Sum(TAB.SS)+(Sum(TAB.MS)/1000.000))
	END As Tiempo,
	TAB.UsuCrea AS NomUsu
FROM
(
SELECT 	RES.RucE,RES.Ejer,RES.Prdo,
	RES.RegCtb,RES.Cd_Fte,Max(RES.FecReg)-Min(RES.FecReg) AS Dif, 
	DATEPART(Hour,Max(RES.FecReg)-Min(RES.FecReg)) AS HH,
	DATEPART(Minute,Max(RES.FecReg)-Min(RES.FecReg)) AS MM,
	DATEPART(Second,Max(RES.FecReg)-Min(RES.FecReg)) AS SS,
	DATEPART(Ms,Max(RES.FecReg)-Min(RES.FecReg)) AS MS,
	RES.UsuCrea
FROM
(	SELECT v.RucE,v.Ejer,v.Cd_Vou,v.RegCtb,v.Cd_Fte,v.UsuCrea,v.FecReg,v.Prdo FROM Voucher v
	WHERE 	v.RucE='''+@RucE+'''
		and v.Ejer='''+@Ejer+'''
		and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
'
SET @SQL4=
'
) AS RES
GROUP BY RES.RucE,RES.Ejer,RES.Prdo,RES.RegCtb,RES.Cd_Fte,RES.UsuCrea
) AS TAB
GROUP BY TAB.Prdo,TAB.Cd_Fte,TAB.UsuCrea
'


PRINT @SQL1
PRINT @CONDICION
PRINT @SQL2

PRINT @SQL3
PRINT @CONDICION
PRINT @SQL4

EXEC(@SQL1+@CONDICION+@SQL2)
EXEC(@SQL3+@CONDICION+@SQL4)

-- Leyenda --
-- DI : 29/04/2011 <Creacion de procedimiento almacenado>
GO

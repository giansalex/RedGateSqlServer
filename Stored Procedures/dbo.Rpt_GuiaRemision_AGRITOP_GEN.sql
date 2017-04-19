SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_GuiaRemision_AGRITOP_GEN]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cadena nvarchar(4000),

@msj varchar(100) output

AS
/*
DECLARE @RucE nvarchar(11)
DECLARE @Ejer nvarchar(4)
DECLARE @Cadena nvarchar(4000)

SET @RucE='20513272848'
SET @Cadena='''GR00000001'''
*/

DECLARE @SQL_CAB varchar(8000) SET @SQL_CAB = ''
DECLARE @SQL_DET1 varchar(8000) SET @SQL_DET1 = ''
DECLARE @SQL_DET2 varchar(8000) SET @SQL_DET2 = ''
DECLARE @SQL_DET3 varchar(8000) SET @SQL_DET3 = ''
DECLARE @SQL_DET4 varchar(8000) SET @SQL_DET4 = ''



SET @SQL_CAB=
	'
SELECT 
	g.RucE,
	e.RSocial,
	g.Cd_GR,
	g.Cd_TD,t.NCorto As NomTD,g.NroSre,g.NroGR,
	Convert(varchar,g.FecEmi,103) AS FecEmi,
	Convert(varchar,g.FecIniTras,103) As FecIniTras,
	Convert(varchar,g.FecFinTras,103) As FecFinTras,
	g.PtoPartida,
	g.Cd_TO,o.Nombre As NomTO,
	g.Cd_Clt,c.NDoc As NroCli,isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) As NomCli,
	g.Cd_Prv,p.NDoc As NroPrv,isnull(p.RSocial,isnull(p.ApPat,'''')+'' ''+isnull(p.ApMat,'''')+'' ''+isnull(p.Nom,'''')) As NomPrv,
	g.Cd_Tra,y.NDoc As NroTra,isnull(y.RSocial,isnull(y.ApPat,'''')+'' ''+isnull(y.ApMat,'''')+'' ''+isnull(y.Nom,'''')) As NomTra,
	g.PesoTotalKg,
	g.AutorizadoPor,
	g.Obs,
	g.Cd_Area,a.Descrip As NomArea,
	g.IC_ES,
	Convert(varchar,g.FecReg,103) As FecReg,
	g.UsuCrea,
	g.CA01,g.CA02,g.CA03,g.CA04,g.CA05,g.CA06,g.CA07,g.CA08,g.CA09,g.CA10,
	g.Cd_CC,g.Cd_SC,g.Cd_SS
FROM 
	GUIAREMISION g
	INNER JOIN Empresa e ON e.Ruc=g.RucE
	INNER JOIN TipDoc t ON t.Cd_TD=g.Cd_TD
	INNER JOIN TipoOperacion o ON o.Cd_TO=g.Cd_TO
	LEFT JOIN Cliente2 c ON c.RucE=g.RucE and c.Cd_Clt=g.Cd_Clt
	LEFT JOIN Proveedor2 p ON p.RucE=g.RucE and p.Cd_Prv=g.Cd_Prv
	LEFT JOIN Transportista y On y.RucE=g.RucE and y.Cd_Tra=g.Cd_Tra
	LEFT JOIN Area a On a.RucE=g.RucE and a.Cd_Area=g.Cd_Area
WHERE 
	g.RUCE='''+@RucE+''' and g.Cd_GR in ('+@Cadena+')
	'


SET @SQL_DET1=
	'
SELECT 
	g.Cd_GR,
	g.Item,
	g.Cd_Prod,p.Nombre1 As Descrip,p.CodCo1_,
	g.ID_UMP,m.NCorto As NCortoUM,
	Isnull(g.Cant,0.00) As Cant,
	v.Total As Precio,
	g.PesoCantKg,
	g.Cd_Vta,
	g.Cd_Com,
	g.ItemPd,
	g.Pend,
	g.CA01,g.CA02,g.CA03,g.CA04,g.CA05
FROM 
	GUIAREMISIONDET g 
	LEFT JOIN Producto2 p ON p.RucE=g.RucE and p.Cd_Prod=g.Cd_Prod
	LEFT JOIN PROD_UM u ON u.RucE=g.RucE and u.Cd_Prod=g.Cd_Prod and u.ID_UMP=g.ID_UMP
	LEFT JOIN UnidadMedida m ON m.Cd_UM=u.Cd_UM
	LEFT JOIN VentaDet v ON v.RucE=g.RucE and v.Cd_Vta=g.Cd_Vta and v.Cd_Prod=g.Cd_Prod
WHERE 
	g.RUCE='''+@RucE+''' and g.Cd_GR in ('+@Cadena+')
	'


SET @SQL_DET2=
	'
SELECT 
	isnull(g.Cd_GR,j.Cd_GR) As Cd_GR,
	j.Cd_Vta,
	v.RegCtb,
	Convert(varchar,v.FecMov,103) AS FecMov,
	Convert(varchar,v.FecED,103) AS FecED,
	Convert(varchar,v.FecVD,103) AS FecVD,
	v.Cd_TD,t.NCorto As NomTD,
	v.NroSre,
	v.NroDoc
FROM GUIAREMISION g
	LEFT JOIN GUIAXVENTA j ON j.RucE=g.RucE and j.Cd_GR=g.Cd_GR
	LEFT JOIN Venta v ON v.RucE=j.RucE and v.Cd_Vta=j.Cd_Vta
	LEFT JOIN TipDoc t ON t.Cd_TD=v.Cd_TD
WHERE 
	g.RUCE='''+@RucE+''' and g.Cd_GR in ('+@Cadena+')
	'

SET @SQL_DET3=
	'
SELECT 
	tem.RucE,
	tem.Cd_GR,
	tem.Item,
	CASE WHEN tem.Item = 1 Then e.RSocial Else g.RSocial End As RSocialPartida,
	CASE WHEN tem.Item = 1 Then e.Direccion Else g.Direc End As Partida,
	tem.RSocial As RSocialLlegada,
	tem.Llegada,
	tem.NroDoc,
	tem.Obs
FROM 
	( SELECT g.RucE,g.Cd_GR,g.Item,g.Direc As Llegada,g.NroDoc,g.RSocial,g.Obs FROM GRPTOLLEGADA g WHERE g.RUCE='''+@RucE+''' and g.Cd_GR in ('+@Cadena+') ) As tem
	LEFT JOIN GRPTOLLEGADA g ON g.RucE=tem.RucE and g.Cd_GR=tem.Cd_GR and g.Item=tem.Item-1
	INNER JOIN EMPRESA e ON e.Ruc=tem.RucE
	'

SET @SQL_DET4=
'
SELECT 
	g.Cd_GR,
	g.Direc As PtoLlegada,
	g.RSocial As RSocial,
	c.NDoc As Ruc
FROM
(	SELECT RucE,Cd_GR,Max(Item) AS Item FROM GRPTOLLEGADA WHERE RUCE='''+@RucE+''' and Cd_GR in ('+@Cadena+') GROUP BY RucE,Cd_GR
) AS TAB
	LEFT JOIN GRPTOLLEGADA g ON g.RucE=TAB.RucE and g.Cd_GR=TAB.Cd_GR and g.Item=TAB.Item
	LEFT JOIN GUIAREMISIOn r ON r.RucE=g.RucE and r.Cd_GR=g.Cd_GR
	LEFT JOIN CLIENTE2 c ON c.RucE=g.RucE and c.Cd_Clt=r.Cd_Clt
WHERE 
	g.RUCE='''+@RucE+''' and g.Cd_GR in ('+@Cadena+')
'


PRINT @SQL_CAB
PRINT @SQL_DET1
PRINT @SQL_DET2
PRINT @SQL_DET3
PRINT @SQL_DET4

EXEC (@SQL_CAB+@SQL_DET1+@SQL_DET2+@SQL_DET3+@SQL_DET4)

-- LEYENDA --
-- DI : 10/03/2011 <Creacion del procedimiento almacenado>
			-- Este procedimiento puede jalar 1 o mas de 1 guia de remision


GO

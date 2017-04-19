SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_Venta_CASAAMARILLA_GEN]
-- PARA FACTURA, BOLETA, NOTA DE CREDITO, NOTA DE DEBITO

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cadena varchar(7950), -- CODIGO(S) DE VENTA
@msj varchar(100) output

AS

--exec [Rpt_Venta_CASAAMARILLA_GEN] '55555555555','2012','''VT00006234''',null
--select * from Venta where RucE = '20507826467' and Eje = '2012' and  RegCtb = 'VTGN_RV11-00023'
DECLARE @SQL_CAB varchar(8000) SET @SQL_CAB = ''
DECLARE @CADENAA varchar(8000) SET @CADENAA = ''
DECLARE @SQL_DET varchar(8000) SET @SQL_DET = ''

SET @CADENAA=' AND v.Cd_Vta in ('+@Cadena+')'

SET @SQL_CAB =
'
SELECT
	v.RucE,e.RSocial,v.Eje,v.Cd_Vta,v.Prdo,v.RegCtb,
	Convert(varchar,v.FecMov,103) As FecMov,
	v.Cd_FPC,f.Nombre As NomFPC,
	Convert(varchar,v.FecCbr,103) As FecCbr,
	v.Cd_TD,t.NCorto As NCortoTD,
	v.NroSre,v.NroDoc,
	Convert(varchar,v.FecED,103) As FecED,
	Convert(varchar,v.FecVD,103) As FecVD,
	v.Cd_Area,a.Descrip As NomArea,
	v.Obs,
	v.Valor,
	v.TotDsctoP,v.TotDsctoI,
	v.ValorNeto,
	v.BaseSinDsctoF,
	v.DsctoFnz_P,v.DsctoFnz_I,
	v.Cd_IAV_DF,
	v.INF_Neto,v.EXO_Neto,v.BIM_Neto,
	v.IGV,v.Total, 
	v.Percep,
	v.Cd_Mda,v.CamMda,
	m.Simbolo,m.Nombre As NomMoneda,
	Convert(varchar,v.FecReg,103) As FecReg,
	v.UsuCrea,
	isnull(v.IB_Anulado,0) As IB_Anulado,
	isnull(v.IB_Cbdo,0) As IB_Cbdo,
	v.DR_CdVta,
	Convert(varchar,v.DR_FecED,103) As DR_FecED,
	v.DR_CdTD,t2.NCorto As NomTDR,
	v.DR_NSre,v.DR_NDoc,isnull(vr.Total,0.00) As DR_Monto,
	v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,v.CA12,v.CA13,v.CA14,v.CA15,v.CA16,v.CA17,v.CA18,v.CA19,v.CA20,v.CA21,v.CA22,v.CA23,v.CA24,v.CA25,
	v.Cd_OP,v.NroOP,v.Cd_CC,v.Cd_SC,v.Cd_SS,
	v.Cd_MIS,
	v.Cd_Clt,c.NDoc As NroCli,isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) As NomCli,
	c.Direc As DirecCli,c.CA01 As CodCli,
	v.Cd_Vdr,d.NDoc As NroVdr,isnull(d.RSocial,isnull(d.ApPat,'''')+'' ''+isnull(d.ApMat,'''')+'' ''+isnull(d.Nom,'''')) As NomVdr,
	v.CostoTot,
	Convert(int,User321.DameIGVImp(Convert(varchar,v.FecMov,103))*100) As RIGV	
	,v.FecED as FecED2
	,v.FecVD as FecVD2
	,isnull(c.CA01,'''') as CA01Cli
	,isnull(c.CA02,'''') as CA02Cli
	,isnull(c.CA03,'''') as CA03Cli
	,isnull(c.CA04,'''') as CA04Cli
	,isnull(c.CA05,'''') as CA05Cli
	,isnull(c.CA06,'''') as CA06Cli
	,isnull(c.CA07,'''') as CA07Cli
	,isnull(c.CA08,'''') as CA08Cli
	,isnull(c.CA09,'''') as CA09Cli
	,isnull(c.CA10,'''') as CA10Cli
 
FROM	Venta v
	LEFT JOIN Empresa e ON e.Ruc=v.RucE
	INNER JOIN FormaPC f ON f.Cd_FPC=v.Cd_FPC
	INNER JOIN TipDoc t ON t.Cd_TD=v.Cd_TD
	LEFT JOIN TipDoc t2 ON t2.Cd_TD=v.DR_CdTD
	INNER JOIN Area a ON a.RucE=v.RucE and a.Cd_Area=v.Cd_Area
	LEFT JOIN Cliente2 c ON c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	LEFT JOIN Vendedor2 d ON d.RucE=v.RucE and d.Cd_Vdr=v.Cd_Vdr
	LEFT JOIN Moneda m ON m.Cd_Mda=v.Cd_Mda
	LEFT JOIN Venta vr ON vr.RucE=v.RucE and vr.Eje=v.Eje and vr.Cd_Vta=v.Cd_Vta
WHERE 	v.RucE='''+@RucE+''' and v.Eje='''+@Ejer+''''


SET @SQL_DET =
'
SELECT 
	v.Cd_Vta,
	v.Nro_RegVdt,
	Convert(decimal(13,2),isnull(v.Cant,0.00)) As Cant,
	isnull(v.PU,0.00) As PU,
	isnull(v.Valor,0.00) As Valor,
	isnull(v.DsctoP,0.00) As DsctoP,
	isnull(v.DsctoI,0.00) As DsctoI,
	isnull(v.IMP,0.00) As IMP,
	isnull(v.IGV,0.00) As IGV,
	isnull(v.Total,0.00) As Total,
	v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,
	Convert(varchar,v.FecReg,103) As FecReg,
	v.UsuCrea,
	v.Cd_CC,v.Cd_SC,v.Cd_SS,
	v.Cd_Srv,
	s.Nombre As NomServ,
	v.Descrip,
	v.ID_UMP,m.NCorto As NCortoUM,
	v.Cd_Alm,a.Nombre As NomAlm,
	v.Obs,
	CASE WHEN g.Cd_TD=''08'' THEN s2.Nombre ELSE '''' END As ServRef,
	CASE len(isnull(v.CA01,'''')) WHEN 4 THEN v.CA01 WHEN 0 THEN '''' ELSE User321.ConvertPrdo_CodANom(isnull(v.CA01,''''),1,0)  END As PrdoRef
FROM 
	VENTADET v
	INNER JOIN VENTA g ON g.RucE=v.RucE and g.Cd_Vta=v.Cd_Vta
	LEFT JOIN PRODUCTO2 p ON p.RucE=v.RucE and p.Cd_Prod=v.Cd_Prod
	LEFT JOIN SERVICIO2 s ON s.RucE=v.RucE and s.Cd_Srv=v.Cd_Srv
	LEFT JOIN ALMACEN a ON a.RucE=v.RucE and a.Cd_Alm=v.Cd_Alm
	LEFT JOIN PROD_UM u ON u.RucE=v.RucE and u.Cd_Prod=v.Cd_Prod and u.ID_UMP=v.ID_UMP
	LEFT JOIN UnidadMedida m ON m.Cd_UM=u.Cd_UM
	LEFT JOIN VENTA g2 ON g2.RucE=g.RucE and g2.Eje=g.Eje and g2.Cd_Vta=g.DR_CdVta
	LEFT JOIN VENTADET d2 ON d2.RucE=g2.RucE and d2.Cd_Vta=g2.Cd_Vta
	LEFT JOIN SERVICIO2 s2 ON s2.RucE=d2.RucE and s2.Cd_Srv=d2.Cd_Srv
WHERE 	v.RucE='''+@RucE+''''

PRINT @SQL_CAB+@CADENAA+' ORDER BY v.NroDoc'

PRINT @SQL_DET+@CADENAA+' ORDER BY 1,2'

EXEC (@SQL_CAB+@CADENAA+' ORDER BY v.NroDoc ')
exec (@SQL_DET+@CADENAA+' ORDER BY 1,2')


GO

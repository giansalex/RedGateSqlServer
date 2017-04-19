SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_Venta_AGRITOP_GEN]
-- PARA FACTURA, BOLETA, NOTA DE CREDITO, NOTA DE DEBITO

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cadena varchar(4000), -- CODIGO(S) DE VENTA
@msj varchar(100) output

AS


DECLARE @SQL_CAB varchar(8000) SET @SQL_CAB = ''
DECLARE @SQL_DET1 varchar(8000) SET @SQL_DET1 = ''
DECLARE @SQL_DET2 varchar(8000) SET @SQL_DET2 = ''


SET @SQL_CAB =
	'
SELECT
	v.RucE,v.Eje,v.Cd_Vta,v.Prdo,v.RegCtb,
	Convert(varchar,v.FecMov,103) As FecMov,
	v.Cd_FPC,f.Nombre As NomFPC,
	Convert(varchar,v.FecCbr,103) As FecCbr,
	v.Cd_TD,t.NCorto As NomTD,
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
	isnull(v.IGV,0.00) As IGV, isnull(v.Total,0.00) As Total, 
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
	v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,v.CA12,v.CA13,v.CA14,v.CA15,
	v.Cd_OP,
	v.NroOP,
	v.Cd_CC,v.Cd_SC,v.Cd_SS,
	v.Cd_MIS,
	v.Cd_Clt,c.NDoc As NroCli,isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) As NomCli,
	c.Direc As DirecCli,c.CA01 As CodCli,
	v.Cd_Vdr,d.NDoc As NroVdr,isnull(d.RSocial,isnull(d.ApPat,'''')+'' ''+isnull(d.ApMat,'''')+'' ''+isnull(d.Nom,'''')) As NomVdr,
	v.CostoTot,
	--Convert(int,User321.DameIGVImp(Convert(varchar,v.FecMov,103))*100) As RIGV
	Convert(int,User321.DameIGVImp(Convert(varchar,Case When isnull(v.DR_FecED,'''')<>'''' Then v.DR_FecED Else v.FecMov End ,103))*100) As RIGV
FROM
	VENTA v
	INNER JOIN FormaPC f ON f.Cd_FPC=v.Cd_FPC
	INNER JOIN TipDoc t ON t.Cd_TD=v.Cd_TD
	LEFT JOIN TipDoc t2 ON t2.Cd_TD=v.DR_CdTD
	INNER JOIN Area a ON a.RucE=v.RucE and a.Cd_Area=v.Cd_Area
	LEFT JOIN Cliente2 c ON c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	LEFT JOIN Vendedor2 d ON d.RucE=v.RucE and d.Cd_Vdr=v.Cd_Vdr
	LEFT JOIN Moneda m ON m.Cd_Mda=v.Cd_Mda
	LEFT JOIN Venta vr ON vr.RucE=v.RucE and vr.Eje=v.Eje and vr.Cd_Vta=v.DR_CdVta
WHERE
	v.RucE='''+@RucE+''' and v.Eje='''+@Ejer+''' and v.Cd_Vta in ('+@Cadena+')
	'

SET @SQL_DET1 =
	'
(
SELECT 
	v.Cd_Vta,
	v.Nro_RegVdt,
	Convert(decimal(13,2),isnull(v.Cant-isnull(convert(decimal(13,3),v.CA01),0),0.00)) As Cant,
	v.PU,
	Convert(decimal(13,2),isnull(v.Valor/* - (isnull(convert(decimal(13,3),v.CA01),0) * v.PU)*/,0.00)) As Valor,
	Convert(decimal(13,2),isnull(v.DsctoP/* - ((v.DsctoP/v.Cant)*isnull(convert(decimal(13,3),v.CA01),0))*/,0.00)) As DsctoP,
	Convert(decimal(13,2),isnull(v.DsctoI/* - ((v.DsctoP/v.Cant)*isnull(convert(decimal(13,3),v.CA01),0))*/,0.00)) As DsctoI,
	Convert(decimal(13,2),isnull(v.IMP/* - (isnull(convert(decimal(13,3),v.CA01),0) * v.PU)*/,0.00)) As IMP,
	Convert(decimal(13,2),isnull(v.IGV/* - ((isnull(convert(decimal(13,3),v.CA01),0) * v.PU) * (User321.DameIGVImp(Convert(varchar,FecMov,103))))*/,0.00)) As IGV,
	Convert(decimal(13,2),isnull(v.Total/* - ((isnull(convert(decimal(13,3),v.CA01),0) * v.PU)+((isnull(convert(decimal(13,3),v.CA01),0) * v.PU) * (User321.DameIGVImp(Convert(varchar,FecMov,103)))))*/,0.00)) As Total,
	v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,
	Convert(varchar,v.FecReg,103) As FecReg,
	v.UsuCrea,
	v.Cd_CC,v.Cd_SC,v.Cd_SS,
	isnull(p.CodCo1_,v.Cd_Srv) As Cd_Prod_Serv,
	case when isnull(v.Cd_Srv,'''')='''' then p.Nombre1 else s.Nombre end As Nom_Prod_Serv,
	v.Descrip+char(10)+isnull(v.Obs,'''') As Descrip,
	v.ID_UMP,m.NCorto As NCortoUM,
	v.Cd_Alm,a.Nombre As NomAlm,
	v.Obs
FROM 
	VENTADET v
	INNER JOIN VENTA g ON g.RucE=v.RucE and g.Cd_Vta=v.Cd_Vta
	LEFT JOIN PRODUCTO2 p ON p.RucE=v.RucE and p.Cd_Prod=v.Cd_Prod
	LEFT JOIN SERVICIO2 s ON s.RucE=v.RucE and s.Cd_Srv=v.Cd_Srv
	LEFT JOIN ALMACEN a ON a.RucE=v.RucE and a.Cd_Alm=v.Cd_Alm
	LEFT JOIN PROD_UM u ON u.RucE=v.RucE and u.Cd_Prod=v.Cd_Prod and u.ID_UMP=v.ID_UMP
	LEFT JOIN UnidadMedida m ON m.Cd_UM=u.Cd_UM
WHERE 
	v.RucE='''+@RucE+''' and v.Cd_Vta in ('+@Cadena+') and isnull(g.CA01,'''')  not in (''DESARROLLO'')
	'

SET @SQL_DET2 =
	'
UNION ALL

SELECT 
	v.Cd_Vta,
	v.Nro_RegVdt+0.1 As Nro_RegVdt,
	Case When isnull(convert(decimal(13,3),v.CA01),0)=0 Then v.Cant Else isnull(convert(decimal(13,3),v.CA01),0) End As Cant,
	v.PU,
	0.00 As Valor,
	0.00 As DsctoP,
	0.00 As DsctoI,
	0.00 As IMP,
	0.00 As IGV,
	0.00 As Total,
	v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,
	Convert(varchar,v.FecReg,103) As FecReg,
	v.UsuCrea,
	v.Cd_CC,v.Cd_SC,v.Cd_SS,
	isnull(p.CodCo1_,v.Cd_Srv) As Cd_Prod_Serv,
	case when isnull(v.Cd_Srv,'''')='''' then p.Nombre1 else s.Nombre end As Nom_Prod_Serv,
	--v.Descrip+char(10)+isnull(v.Obs,'''')+Case When isnull(convert(decimal(13,3),v.CA01),0) > 0 Then '' - BONIFICACION'' Else '''' End+char(10)+ ''VALOR REFERENCIAL. TOTAL (''+mo.Simbolo+Convert(varchar,v.PU)+'' X ''+Convert(varchar,Convert(decimal(13,2),isnull(v.Cant-isnull(convert(decimal(13,3),v.CA01),0),0.00)))+'')=''+Convert(varchar,Convert(decimal(13,2),isnull(v.IMP - (isnull(convert(decimal(13,3),v.CA01),0) * v.PU),0.00))) As Descrip,
	v.Descrip+char(10)+isnull(v.Obs,'''')+Case When isnull(convert(decimal(13,3),v.CA01),0) > 0 Then '' - BONIFICACION'' Else '''' End+char(10)+ ''VALOR REFERENCIAL. TOTAL (''+mo.Simbolo+Convert(varchar,v.PU)+'' X ''+Convert(varchar,Convert(decimal(13,2),isnull(convert(decimal(13,3),isnull(v.CA01,v.Cant)),0.00)))+'')=''+Convert(varchar,Convert(decimal(13,2),isnull((isnull(convert(decimal(13,3),isnull(v.CA01,v.Cant)),0) * v.PU),0.00))) As Descrip,
	v.ID_UMP,m.NCorto As NCortoUM,
	v.Cd_Alm,a.Nombre As NomAlm,
	v.Obs
FROM 
	VENTADET v
	INNER JOIN VENTA g ON g.RucE=v.RucE and g.Cd_Vta=v.Cd_Vta
	LEFT JOIN PRODUCTO2 p ON p.RucE=v.RucE and p.Cd_Prod=v.Cd_Prod
	LEFT JOIN SERVICIO2 s ON s.RucE=v.RucE and s.Cd_Srv=v.Cd_Srv
	LEFT JOIN ALMACEN a ON a.RucE=v.RucE and a.Cd_Alm=v.Cd_Alm
	LEFT JOIN PROD_UM u ON u.RucE=v.RucE and u.Cd_Prod=v.Cd_Prod and u.ID_UMP=v.ID_UMP
	LEFT JOIN UnidadMedida m ON m.Cd_UM=u.Cd_UM
	LEFT JOIN Moneda mo ON mo.Cd_Mda=g.Cd_Mda
WHERE 
	v.RucE='''+@RucE+''' and v.Cd_Vta in ('+@Cadena+')
	and (isnull(convert(decimal(13,3),v.CA01),0) > 0 or g.CA01 in (''DESARROLLO''))
)
ORDER BY 1,2
	'

PRINT @SQL_CAB
PRINT @SQL_DET1
PRINT @SQL_DET2

EXEC (@SQL_CAB+@SQL_DET1+@SQL_DET2)

-- LEYENDA --
-- DI : 07/03/2011 <Creacion del procedimiento almacenado>
			-- Este procedimiento puede jalar 1 o mas de 1 venta
GO

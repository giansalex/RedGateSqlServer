SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Vta_Anulados_Cons '11111111111','2012','01/01/2012','15/06/2012',null
CREATE procedure [dbo].[Vta_Anulados_Cons]
@RucE nvarchar(11),
@Ejer varchar(4),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output
as
--set @RucE='11111111111'
--set @Ejer='2011'
--set @FecIni='01/01/2011'
--set @FecFin='15/06/2011'
if not exists ( select top 1 *from Venta v where RucE=@RucE and Eje=@Ejer and Isnull(IB_Anulado,0)=1)
		set @msj='No hay ventas anuladas'
select 
	convert(bit,0) as Sel,v.Cd_Vta, v.Prdo, v.RegCtb, Convert(varchar,v.FecMov,103) FecMov
	, v.Cd_FPC, Convert(varchar,v.FecCbr,103) FecCbr, v.Cd_TD, t.NCorto
	, v.NroSre, v.NroDoc, Convert(varchar,v.FecED,103) FecED, Convert(varchar,v.FecVD,103) FecVD
	, c2.NDoc as NDocClt, case when isnull(c2.RSocial,'')='' then ISNULL(c2.ApPat,'')+' '+ISNULL(c2.ApMat,'')+' '+ISNULL(c2.Nom,'') else ISNULL(c2.RSocial,'') end as RSocialClt
	, v2.NDoc as NDocVdr, case when isnull(v2.RSocial,'')='' then ISNULL(v2.ApPat,'')+' '+ISNULL(v2.ApMat,'')+' '+ISNULL(v2.Nom,'') else ISNULL(v2.RSocial,'') end as RSocialVdr
	, v.Cd_MIS, v.Cd_Area, v.Cd_MR, v.Obs
	, v.Valor, v.TotDsctoP, v.TotDsctoI, v.ValorNeto
	, v.BaseSinDsctoF, v.DsctoFnz_P, v.DsctoFnz_I, v.Cd_IAV_DF
	, v.INF_Neto, v.EXO_Neto, v.EXPO_Neto, v.BIM_Neto
	, v.CostoTot, v.IGV, v.Total, v.Percep
	, v.Cd_Mda, v.CamMda, v.DR_CdVta, convert(varchar,v.DR_FecED,103) DR_FecED
	, v.DR_CdTD, v.DR_NSre, v.DR_NDoc, v.Cd_CC
	, v.Cd_SC, v.Cd_SS, v.Cd_OP, v.NroOP
	, Convert(bit,v.IB_Cbdo) IB_Cbdo, Convert(bit,v.IB_Anulado) IB_Anulado, v.MtvoBaja, v.CA01, v.CA02, v.CA03, v.CA04
	, v.CA05, v.CA06, v.CA07, v.CA08, v.CA09, v.CA10, v.CA11, v.CA12
	, v.CA13, v.CA14, v.CA15, v.CA16, v.CA17, v.CA18, v.CA19, v.CA20
	, v.CA21, v.CA22, v.CA23, v.CA24, v.CA25, v.FecMdf, v.UsuCrea, v.UsuModf
from 
	Venta v inner join Cliente2 c2 on c2.RucE=v.RucE and c2.Cd_Clt=v.Cd_Clt
	left join Vendedor2 v2 on v2.RucE=v.RucE and v2.Cd_Vdr=v.Cd_Vdr
	inner join TipDoc t on t.Cd_TD=v.Cd_TD
where 
	v.RucE=@RucE and Eje=@Ejer and isnull(IB_Anulado,0)=1
	and v.FecMov between @FecIni and @FecFin



select 
	vd.Cd_Vta
	, vd.Nro_RegVdt
	, case when ISNULL(vd.Cd_Prod,'')='' then ISNULL(vd.Cd_Srv,'') else ISNULL(vd.Cd_Prod,'') end as Codigo
	, vd.Descrip
	, vd.ID_UMP
	, vd.Cd_Alm
	, vd.Cd_IAV
	, vd.Cant
	, vd.PU
	, vd.CU
	, vd.Costo
	, vd.Valor
	, vd.DsctoP
	, vd.DsctoI
	, vd.IMP
	, vd.IGV
	, vd.Total
	, vd.Cd_CC
	, vd.Cd_SC
	, vd.Cd_SS
	, vd.CA01
	, vd.CA02
	, vd.CA03
	, vd.CA04
	, vd.CA05
	, vd.CA06
	, vd.CA07
	, vd.CA08
	, vd.CA09
	, vd.CA10
from 
	Venta v inner join VentaDet vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta
where 
	v.RucE=@RucE and v.Eje=@Ejer and isnull(v.IB_Anulado,0)=1
	and v.FecMov between @FecIni and @FecFin

-- 19/04/2017 - GS -> Add parameter MotivoBaja
GO

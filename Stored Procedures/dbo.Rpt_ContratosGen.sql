SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_ContratosGen]
@RucE nvarchar(11), @FecIni datetime , @FecFin datetime, @Cd_CC nvarchar(11),@Cd_SC nvarchar(11),@Cd_SS nvarchar(11),@Tipo char(1)
as
--set @RucE = '20101949461'
--set @Ejer = '2012'
--set @FecIni = '01/01/2012'
--set @FecFin = '31/03/2012'
--set @Cd_CC = ''
--set @Cd_SC = ''
--set @Cd_SS = ''


select 
c.RucE,
c.Cd_ctt,
case when isnull(c.Cd_Clt,'') <> '' then c.Cd_Clt else isnull(c.Cd_Prv,'') end as Cd_CltPrv,
case When isnull(c.Cd_Clt,'')='' and isnull(c.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
Else Case When isnull(c.Cd_Clt,'')<>'' Then isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,'')) 
Else isnull(prv.RSocial,isnull(prv.ApPat,'')+' '+isnull(prv.ApMat,'')+' '+isnull(prv.Nom,'')) 
End End As NomCliPrv,
c.FecIni,
c.FecFin,
c.FecReg,
DATEDIFF(day, GETDATE(),c.FecFin) as SaldoDias,
c.Descrip,
c.UsuCrea,
c.Estado,
isnull(cc.Descrip,'') as Nom_CC,
isnull(cs.Descrip,'') as Nom_SC,
--isnull(ss.Descrip,'') as Nom_SS,
isnull(ss.NCorto,'') as Nom_SS,
c.Cd_CC,
c.Cd_SC,
c.Cd_SS,
case when DATEDIFF(day, GETDATE(),c.FecFin)<0 then 'Vencido' else 'Por vencer' end as Mensaje,
c.CA01 as CA01,
c.CA02 as CA02,
c.CA03 as CA03,
c.CA04 as CA04,
c.CA05 as CA05,
c.CA06 as CA06,
c.CA07 as CA07,
c.CA08 as CA08,
c.CA09 as CA09,
c.CA10 as CA10,
c.CA11 as CA11,
c.CA12 as CA12,
c.CA13 as CA13,
c.CA14 as CA14,
c.CA15 as CA15,
c.CA16 as CA16,
c.CA17 as CA17,
c.CA18 as CA18,
c.CA19 as CA19,
c.CA20 as CA20,
'' as Estado,
isnull(cd.IC_TipDet,'') as IC_TipDet,
case cd.IC_TipDet when 'C' then 'CPI' when 'I' then 'IDX' when 'D' then 'DEF'  else '' end as CptoDet

from Contrato c 
left join ContratoDet cd on cd.RucE = c.RucE and cd.Cd_Ctt = c.Cd_Ctt and cd.Item = case when exists(select top 1 * from Contrato where RucE = @RucE) then '1' else '' end 
left join Cliente2 clt on c.RucE = clt.RucE and c.Cd_Clt= clt.Cd_Clt
left join Proveedor2 prv on c.RucE = prv.RucE and c.Cd_Prv = prv.Cd_Prv
left join CCostos cc on cc.RucE = c.RucE and c.Cd_CC = cc.Cd_CC
left join CCSub cs on cs.RucE = c.RucE and c.Cd_SC = cs.Cd_SC and cs.Cd_CC = cc.Cd_CC
left join CCSubSub ss  on ss.RucE = c.RucE and c.Cd_SS = ss.Cd_SS and ss.Cd_CC = c.Cd_CC and ss.Cd_SC = c.Cd_SC
where 
c.RucE = @RucE
--and c.FecFin between @FecIni and @FecFin
and case when @Tipo = 'H' then convert(nvarchar,c.FecIni,103) else convert(nvarchar,c.FecFin,103) end between @FecIni and @FecFin
--and convert(nvarchar,c.FecIni,103) between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
and case when ISNULL(@Cd_CC,'')<>''then c.Cd_CC else '' end  = ISNULL(@Cd_CC,'')
and case when ISNULL(@Cd_SC,'')<>''then c.Cd_SC else '' end  = ISNULL(@Cd_SC,'')
and case when ISNULL(@Cd_SS,'')<>''then c.Cd_SS else '' end  = ISNULL(@Cd_SS,'')


/****Datos Generales****/
select RSocial,Ruc,Direccion,Telef, 'Del '+convert(nvarchar,@FecIni,103)+' al '+convert(nvarchar,@FecFin,103) as FecDesde  from Empresa where Ruc = @RucE 

--Leyenda--
--<Creacion: JA> 07/03/2012
--<Modificacion: JA> 20/03/2012 -le agrege la columna Estado
--exec Rpt_ContratosGen '20101949461','01/06/2012','30/06/2012','','',''
-- DI : 08/11/2012 se cambio convert(nvarchar,c.FecFin,103) por convert(nvarchar,c.FecIni,103) en el WHERE

GO

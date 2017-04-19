SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare
CREATE procedure [dbo].[Rpt_VentaXLetra]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vdr nvarchar(10),
@Cd_Clt nvarchar(10),
@FecIni datetime,
@FecFin datetime,
@Ib_Incluir bit,
@Cd_Mda nvarchar(2)


--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @Cd_Vdr = ''
--set @Cd_Clt = 'CLT0000043'
--set @FecIni = '23/11/2012'
--set @FecFin = '23/11/2012'
--set @Ib_Incluir = 0
--set @Cd_Mda = '02'
--exec [Rpt_VentaXLetra] '20102028687','2012','','','01/10/2012','31/12/2012',0,'02'
--select * from Venta where RucE = '20102028687' and Cd_Vta in('VT00000822','VT00000824','VT00000737') and Eje = '2013' and cd_td = '07'
--select * from CanjeDet where RucE = '20102028687' and Cd_TD = '07'
as
select *,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons,@Cd_Mda as MdaCons from Empresa Where Ruc = @RucE


select
v.Cd_Vta
,v.NroSre+'-'+v.NroDoc as Fact
,gv.Cd_GR
,gr.NroSre+'-'+gr.NroGR as Guia
,v.FecMov
,v.Cd_Clt
,ISNULL(clt.Rsocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,'')) +case when isnull(v.IB_Anulado,0)=1 then ' (ANULADO)' else '' end  as Cliente
,v.Cd_Vdr
,ISNULL(vdr.Rsocial,isnull(vdr.ApPat,'')+' '+isnull(vdr.ApMat,'')+' '+isnull(vdr.Nom,'')) as Vendedor
,case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when @Cd_Mda = v.Cd_Mda then isnull(v.Total,0) else case when @Cd_Mda = '01' then isnull(v.CamMda,0.00)*isnull(v.Total,0) else isnull(v.Total,0)/isnull(v.CamMda,0.00)end end end as Total
,case when isnull(lc.NroLtr,'')='' then v.CA01 else 'LETRA A '+convert(nvarchar,DATEDIFF(day,v.FecMov,lc.FecVenc))+' DIAS' end as CondPago
,isnull(lc.NroLtr,'') as NroLtr
,lc.FecVenc

from
Venta v
left join CanjeDet cd on cd.RucE = v.RucE and cd.Cd_Vta = v.Cd_Vta
left join GuiaXVenta gv on gv.RucE = v.RucE and gv.Cd_Vta = v.Cd_Vta
left join GuiaRemision gr on gr.RucE = v.RucE and gr.Cd_GR = gv.Cd_GR
left join Canje c on c.RucE = v.RucE and c.Ejer = v.Eje and cd.Cd_Cnj = c.Cd_Cnj
left join Letra_Cobro lc on lc.RucE = v.RucE and lc.Cd_cnj = c.Cd_Cnj
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt
left join Vendedor2 vdr on vdr.RucE = v.RucE and vdr.Cd_Vdr = v.Cd_Vdr
where v.RucE = @RucE and v.FecMov between @FecIni and @FecFin
and case when ISNULL(@Cd_Clt,'')='' then '' else v.Cd_Clt end = ISNULL(@Cd_Clt,'')
and case when ISNULL(@Cd_Vdr,'')='' then '' else v.Cd_Vdr end = ISNULL(@Cd_Vdr,'')
and isnull(case when @Ib_Incluir = 1 then '' else v.Cd_Mda end,'') = isnull(case when @Ib_Incluir = 1 then '' else @Cd_Mda end,'')
order by v.Cd_Vta
--<Creado: JA><20/01/2013>


GO

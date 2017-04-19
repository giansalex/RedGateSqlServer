SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--declare 
CREATE Procedure [dbo].[Rpt_ConsPedidoCotizacion]
@RucE nvarchar(11),
@Cd_Vdr nvarchar(7),
@Ib_Pendiente bit,
@FecIni datetime,
@FecFin datetime,
@Cd_Mda char(2),
@Ib_Incluir bit,
@Ib_SoloPendiente bit,
@Parcial varchar(1)


as
--exec [Rpt_ConsCotizacion] '20102028687','',1,'01/09/2012','30/09/2012','02',1,1
--set @RucE = '20102028687'
--set @Cd_Vdr = ''
--set @Ib_Pendiente = 0
--set @FecIni = '01/08/2012'
--set @FecFin = '31/08/2012'
--set @Cd_Mda = '01'
--set @Ib_Incluir = 1 --Incluir ambas monedas, Soles, Dolares 




select e.*,@FecIni as FecDesde,@FecFin as FecHasta from Empresa e where e.Ruc = @RucE


select 
/*******************************Cabecera*****************************************/
c.RucE,c.Cd_Cot,c.NroCot,c.FecEmi,c.FecCad,c.Cd_FPC,c.Asunto,c.Cd_Cte
,c.Cd_Clt
,isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,'')) as Cliente
,c.Cd_Vdr
,isnull(vdr.RSocial,isnull(vdr.ApPat,'')+' '+isnull(vdr.ApMat,'')+' '+isnull(vdr.Nom,'')) as Vendedor
,c.Cd_Mda
,c.CamMda
,c.Cd_Area,c.Obs,c.UsuCrea,c.UsuMdf
,c.CA01,c.CA02,c.CA03,c.CA04,c.CA05
/************************************************************************/
/*******************************Detalle*****************************************/
,isnull(cd.Cd_Prod,cd.Cd_Srv) as Cd_PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.Nombre1 else s.Nombre end as NomPrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.Descrip else s.Descrip end as DescripPrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CodCo1_ else s.CodCo end as CodCoPrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA01 else '' end as CA01PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA02 else '' end as CA02PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA03 else '' end as CA03rSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA04 else '' end as CA04PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA05 else '' end as CA05PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA06 else '' end as CA06PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA07 else '' end as CA07PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA08 else '' end as CA08PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA09 else '' end as CA09PrSrv
,case when isnull(cd.Cd_Prod,'')<>'' then p.CA10 else '' end as CA10PrSrv
,um.NCorto as NCorotoUM_Det
,isnull(cd.Descrip,'') as DescripPrSrv_Det
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.PU,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.PU,0.00) else isnull(cd.PU,0.00)/isnull(c.CamMda,0.00)end end as PU_Det
,cd.cant as CantDet
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.Valor,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.Valor,0.00) else isnull(cd.Valor,0.00)/isnull(c.CamMda,0.00)end end as Valor_Det
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.DsctoI,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.DsctoI,0.00) else isnull(cd.DsctoI,0.00)/isnull(c.CamMda,0.00)end end as DsctoI_Det
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.BIM,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.BIM,0.00) else isnull(cd.BIM,0.00)/isnull(c.CamMda,0.00)end end as BIM_Det
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.IGV,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.IGV,0.00) else isnull(cd.IGV,0.00)/isnull(c.CamMda,0.00)end end as IGV_Det
,case when @Cd_Mda = c.Cd_Mda then isnull(cd.Total,0.00) else case when @Cd_Mda = '01' then isnull(c.CamMda,0.00)*isnull(cd.Total,0.00) else isnull(cd.Total,0.00)/isnull(c.CamMda,0.00)end end as Total_Det
,cd.Obs as ObsDet
,cd.CA01 as CA01Det
,cd.CA02 as CA02Det
,cd.CA03 as CA03Det
,cd.CA04 as CA04Det
,cd.CA05 as CA05Det
/************************************************************************/
,op.NroOP
,op.Cd_OP 
,op.FecE as FecPedido
,vdr.ca03 as CA03Vdr
from Cotizacion c
left join OrdPedido op on op.RucE = c.RucE and op.Cd_Cot = c.Cd_Cot
left join Cliente2 clt on clt.RucE = c.RucE and clt.Cd_Clt = c.Cd_Clt
left join Vendedor2 vdr on vdr.RucE = c.RucE and vdr.Cd_Vdr = c.Cd_Vdr
--left join CotizacionDet cd on cd.RucE = c.RucE and cd.Cd_Cot = c.Cd_Cot
left join OrdPedidoDet cd on cd.RucE = c.RucE and cd.Cd_OP = op.Cd_OP
left join Producto2 p on p.RucE = c.RucE and p.Cd_Prod = cd.Cd_Prod
left join Servicio2 s on s.RucE = c.RucE and s.Cd_Srv = cd.Cd_Srv
left join Prod_UM ump on ump.RucE = c.RucE and ump.Cd_Prod = p.Cd_Prod and ump.ID_UMP = cd.ID_UMP
left join UnidadMedida um on um.Cd_UM = ump.Cd_UM
where 
c.RucE = @RucE
and isnull(case when @Ib_Incluir = 1 then '' else c.Cd_Mda end,'') = isnull(case when @Ib_Incluir = 1 then '' else @Cd_Mda end,'')
and c.FecEmi between @FecIni and @FecFin
and case when isnull(@Cd_Vdr,'') <>  '' then c.Cd_Vdr else '' end = isnull(@Cd_Vdr,'') 
--and isnull(case when @Ib_Pendiente = 1 then op.Cd_OP else '' end,'') = ''
and case when @Ib_Pendiente = 0 then isnull(op.Cd_OP,'') else 'X' end <>''
and isnull(case when @Ib_SoloPendiente = 1 then op.Cd_OP else 'X' end,'') = case when @Ib_SoloPendiente = 1 then '' else 'X' end 
and ISNULL(c.CA11,'') = case @Parcial when 'A' then ISNULL(c.CA11,'')
										when 'S' then 'SI'
										when 'N' then 'NO' end

--<Creado: JA>
--14/09/2012
--Procedure creado para los diferentes reportes de cotizacion.


GO

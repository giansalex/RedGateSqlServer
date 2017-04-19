SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare
CREATE Procedure [dbo].[Rpt_KardexSimple]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prod nvarchar(7),
@FecHasta datetime

--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @Cd_Prod = 'PD00008'
--set @FecHasta = '13/12/2012'
as 

select e.* from Empresa e Where e.Ruc = @RucE

select 
i.*,
p.*,
clt.NDoc as NDocCli,
clt.RSocial as RSocialCli,
clt.ApPat as ApPatCli,
clt.ApMat as ApMatCli,
clt.Nom as NomCli,
prv.NDoc as NDocPrv,
prv.RSocial as RSocialPrv,
prv.ApPat as ApPatPrv,
prv.ApMat as ApMatPrv,
prv.Nom as NomPrv,
gr.NroGR as NroGuia,
gr.NroSre as NroSreGuia,
case when isnull(@Cd_Prod,'')='' then '0' else '1' end as MuestraProd
from 
Inventario i
left join Producto2 p on p.RucE = i.RucE and p.Cd_Prod = i.Cd_Prod
left join Proveedor2 prv on prv.RucE = i.RucE and prv.Cd_Prv = i.Cd_Prv
left join Cliente2 clt on clt.RucE = i.RucE and clt.Cd_Clt = i.Cd_Clt
left join GuiaRemision gr on gr.RucE = i.RucE and gr.Cd_GR = i.Cd_GR
where 
i.RucE = @RucE 
and case when isnull(@Ejer,'') <> '' then i.Ejer else '' end = isnull(@Ejer,'') 
and i.FecMov <@FecHasta
and case when isnull(@Cd_Prod,'') <> '' then p.Cd_Prod else '' end = isnull(@Cd_Prod,'') 
order by FecMov

--exec Rpt_KardexSimple '20102028687','2012','PD00008','13/12/2012'
--<JA:Creado><13/12/2012>


GO

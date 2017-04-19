SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasxCbrDet_PurePeru]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@Cd_Clt nvarchar(10),
@NroCtaDesde nvarchar(11),
@NroCtaHasta nvarchar(11),
@VerSaldados bit
as
set language spanish

--set @RucE = '20527146136'
--set @Ejer = '2012'
--set @FecIni = '01/01/2012'
--set @FecFin = '30/06/2012'
--set @Cd_Clt = ''
--set @NroCtaDesde = '23.5.1.21' 
--set @NroCtaHasta = '23.5.1.21'
--set @VerSaldados = 0



Select e.*,'Desde '+Convert(nvarchar,@FecIni,103)+' Hasta el '+Convert(nvarchar,@FecFin,103) as FecCons, @NroCtaDesde as NroCtaDesde , @NroCtaHasta as NroCtaDesde1 
,(select NomCta from PlanCtas where RucE = @RucE and Ejer = @Ejer and NroCta = @NroCtaDesde ) as NomCtaD
,(select NomCta from PlanCtas where RucE = @RucE and Ejer = @Ejer and NroCta = @NroCtaHasta ) as NomCtaH
from Empresa e 
Where e.Ruc = @RucE

select 
	v.RucE,v.Ejer,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc
	,Max(isnull(res.FecMov,'')) As FecED
	,Max(Case When isnull(res.FecMov,'')<>'' Then isnull(v.Cd_Clt,v.Cd_Prv) Else '' End) As Cd_Aux
	,Max(Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.NDoc,'')
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.NDoc,'')
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Doc Auxiliar--' 
												end 
	end ) As NDocAux
	,Max(Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.RSocial,isnull(c.ApPat,'') +' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.RSocial,isnull(pr.ApPat,'') +' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Auxiliar--' 
												end 
	end ) As Auxiliar
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Glosa Else '' End) As Glosa
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Cd_SS Else '' End) As Cd_SS
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Cd_MdRg Else '' End) As MdaReg
	,Max(Case When isnull(res.FecMov,'')<>'' Then isnull(v.FecCbr,v.FecVD) Else '' End) As FecVD
	,sum(v.MtoD) - sum(v.MtoH) as Saldo,sum(v.MtoD_ME)-sum(v.MtoH_ME) as Saldo_ME
from 
	Voucher v
	inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
	left join Cliente2 c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt
	left join Proveedor2 pr on pr.RucE = v.RucE and pr.Cd_Prv = v.Cd_Prv
	left join 
			(	select v.NroCta,isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,Min(v.FecMov) As FecMov
				from Voucher v inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
				where v.RucE = @RucE and v.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin + ' 23:59:29' and isnull(p.IB_CtasXCbr,0) = 1 and v.NroCta between @NroCtaDesde and @NroCtaHasta
				group by v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc
			) res On res.NroCta=v.NroCta and res.Cd_TD=isnull(v.Cd_TD,'') and res.NroSre=isnull(v.NroSre,'') and res.NroDoc=isnull(v.NroDoc,'') and res.FecMov=v.FecMov
where 
v.RucE = @RucE 
and v.Ejer = @Ejer 
and v.FecMov between @FecIni and @FecFin + ' 23:59:29' 
and isnull(p.IB_CtasXCbr,0) = 1 
and v.NroCta between @NroCtaDesde and @NroCtaHasta
and case when isnull(@Cd_Clt,'') = '' then '' else v.Cd_Clt end = isnull(@Cd_Clt,'')
group by 
v.RucE,v.Ejer,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc
having sum(v.MtoD) - sum(v.MtoH) + @VerSaldados<> 0 and sum(v.MtoD_ME)-sum(v.MtoH_ME) +@VerSaldados <>0 
order by v.Cd_TD,v.NroSre,v.NroDoc


--<JA: Creado 13/09/2012>
--Exec Rpt_CtasxCbrDet_PurePeru '20527146136','2012','01/01/2012','30/06/2012','','23.5.1.21','23.5.1.21',0

GO

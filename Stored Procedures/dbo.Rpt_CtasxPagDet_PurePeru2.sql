SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_CtasxPagDet_PurePeru2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@Cd_Prv nvarchar(10),
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


Select e.*,'Desde '+Convert(nvarchar,@FecIni,103)+' Hasta el '+Convert(nvarchar,@FecFin,103) as FecCons, @NroCtaDesde as NroCtaDesde , @NroCtaHasta as NroCtaDesde 
,p.NomCta as NomCtaD
,p1.NomCta as NomCtaH
from Empresa e
left join PlanCtas p on p.RucE = e.Ruc and p.Ejer = @Ejer and p.NroCta = @NroCtaDesde
left join PlanCtas p1 on p1.RucE = e.Ruc and p1.Ejer = @Ejer and p1.NroCta = @NroCtaHasta
Where e.Ruc = @RucE

select 
	v.RucE,v.Ejer,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc
	,Max(isnull(res.FecMov,'')) As FecED
	,Max(Case When isnull(res.FecMov,'')<>'' Then isnull(v.Cd_Clt,v.Cd_Prv) Else '' End) As Cd_Aux
	--,max(Case When isnull(res.FecMov,'')<>'' Then 
	--											case 
	--												when isnull(v.Cd_Clt,'')<> '' then isnull(c.NDoc,'')
	--												when isnull(v.Cd_Prv,'')<> '' then isnull(pr.NDoc,'')
	--												when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Doc Auxiliar--' 
	--											end 
	--end ) As NDocAux
	,Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.NDoc,'')
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.NDoc,'')
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Doc Auxiliar--' 
												end 
	end As NDocAux
	--,Max(Case When isnull(res.FecMov,'')<>'' Then 
	--											case 
	--												when isnull(v.Cd_Clt,'')<> '' then isnull(c.RSocial,isnull(c.ApPat,'') +' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
	--												when isnull(v.Cd_Prv,'')<> '' then isnull(pr.RSocial,isnull(pr.ApPat,'') +' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
	--												when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Auxiliar--' 
	--											end 
	--end ) As Auxiliar
	,Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.RSocial,isnull(c.ApPat,'') +' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.RSocial,isnull(pr.ApPat,'') +' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Auxiliar--' 
												end 
	end As Auxiliar
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Glosa Else '' End) As Glosa
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Cd_SS Else '' End) As Cd_SS
	,Max(Case When isnull(res.FecMov,'')<>'' Then v.Cd_MdRg Else '' End) As MdaReg
	,Max(Case When isnull(res.FecMov,'')<>'' Then isnull(v.FecCbr,v.FecVD) Else '' End) As FecVD
	,sum(v.MtoD)-sum(v.MtoH) as Saldo
	,sum(v.MtoD_ME)-sum(v.MtoH_ME) as Saldo_ME
from 
	Voucher v
	inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
	left join Cliente2 c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt
	left join Proveedor2 pr on pr.RucE = v.RucE and pr.Cd_Prv = v.Cd_Prv
	inner join 
			(	select v.NroCta,isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,Min(v.FecMov) As FecMov,v.Cd_SS
				from Voucher v inner join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta
				where v.RucE = @RucE and v.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin + ' 23:59:29' and isnull(p.IB_CtasXPag,0) = 1 and v.NroCta between @NroCtaDesde and @NroCtaHasta
				and case when isnull(@Cd_Prv,'')<>'' then isnull(v.Cd_Prv,'') else '' end = isnull(@Cd_Prv,'') 
				group by v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_SS--,isnull(v.Cd_Clt,v.Cd_Prv)
				having sum(v.MtoD) - sum(v.MtoH) + @VerSaldados<> 0 and sum(v.MtoD_ME)-sum(v.MtoH_ME) +@VerSaldados <>0 
			) res On res.NroCta=v.NroCta and res.Cd_TD=isnull(v.Cd_TD,'') and res.NroSre=isnull(v.NroSre,'') and res.NroDoc=isnull(v.NroDoc,'') /*and convert(nvarchar,res.FecMov,103)=convert(nvarchar,v.FecMov,103)*/ and res.Cd_SS = v.Cd_SS
where v.RucE = @RucE and v.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin + ' 23:59:29' and isnull(p.IB_CtasXPag,0) = 1 and v.NroCta between @NroCtaDesde and @NroCtaHasta 
and case when isnull(@Cd_Prv,'')<>'' then isnull(v.Cd_Prv,'') else '' end = isnull(@Cd_Prv,'') 
group by 
v.RucE,v.Ejer,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_SS
,Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.NDoc,'')
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.NDoc,'')
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Doc Auxiliar--' 
												end 
	end
,Case When isnull(res.FecMov,'')<>'' Then 
												case 
													when isnull(v.Cd_Clt,'')<> '' then isnull(c.RSocial,isnull(c.ApPat,'') +' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
													when isnull(v.Cd_Prv,'')<> '' then isnull(pr.RSocial,isnull(pr.ApPat,'') +' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
													when isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' then '--Sin Auxiliar--' 
												end 
	end
having sum(v.MtoD) - sum(v.MtoH) + @VerSaldados<> 0 and sum(v.MtoD_ME)-sum(v.MtoH_ME) +@VerSaldados <>0 
order by v.Cd_TD,v.NroSre,v.NroDoc

--<JA: Creado 16/10/2012>
--Exec Rpt_CtasxPagDet_PurePeru2 '20527146136','2012','01/01/2012','31/12/2012','','41.5.1.10','41.5.1.10',0
--set language spanish
--Exec Rpt_CtasxPagDet_PurePeru2 '20527146136','2012','01/01/2012','30/09/2012','PRV1358','42.2.1.20','42.2.1.20',1

--select * from Voucher where RucE = '20527146136' and Ejer = '2012' and NroDoc = '000017' and NroCta = '42.4.1.20' and Cd_Prv = 'PRV0556' and Prdo = '11' and isnull(Cd_Prv,'')='' and ISNULL(cd_Clt,'')=''
--select * from Voucher where RucE = '20527146136' and Ejer = '2012' and RegCtb = 'CTGN_LD07-00343'

GO

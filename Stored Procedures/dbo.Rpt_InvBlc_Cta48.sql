SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select * from Empresa where Ruc = '20521620090'
--select  * from PlanCtas where RucE = '20521620090' and ejer = '2012' and NroCta like '48%' 
CREATE procedure [dbo].[Rpt_InvBlc_Cta48]
--declare 
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@msj nvarchar(100) output

--set @RucE = '20521620090'
--set @Ejer = '2012'
--set @FecIni = '01/01/2012'
--set @FecFin = '31/12/2012'
--exec Rpt_InvBlc_Cta48 '20521620090','2012','01/01/2012','31/12/2012',null
as

if not exists(select top 1 *  from voucher v where v.RucE = @RucE and v.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin and v.NroCta like '48%')
begin 
set @msj = 'No se encontraron registros de esta cuenta.'
print @msj
end
else
begin
select *,@Ejer as Ejer from Empresa where Ruc = @RucE

select
dbo.NivelCuenta(v.NroCta,2) as Cta_Det,
p.NomCta as NomCta_Det,
dbo.NivelCuenta(v.NroCta,3) as Cta_Desc,
p1.NomCta as NomCta_Desc,
v.NroCta,
p2.NomCta,
v.Cd_MdRg, 
case when v.Cd_MdRg = '01' then 'S/.' else 'US$' end as SimMda,
sum(v.MtoD) as MtoD,
sum(v.MtoH) as MtoH,
sum(v.MtoD-v.MtoH) as Saldo,
sum(v.MtoD_ME) as MtoD_ME,
sum(v.MtoH_ME) as MtoH_ME,
sum(v.MtoD_ME-v.MtoH_ME) as Saldo_ME,
isnull(v.Cd_Clt,v.Cd_Prv) as Cd_Aux,
case when isnull(v.Cd_Clt,'') <> '' then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
	when isnull(v.Cd_Prv,'') <> '' then isnull(pr.RSocial,isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
	else '--Sin Auxiliar--' end as NomAux

from voucher v
left join PlanCtas p on p.RucE = v.rucE and p.Ejer = v.Ejer and p.NroCta = dbo.NivelCuenta(v.NroCta,2)
left join PlanCtas p1 on p1.RucE = v.rucE and p1.Ejer = v.Ejer and p1.NroCta = dbo.NivelCuenta(v.NroCta,3)
left join PlanCtas p2 on p2.RucE = v.rucE and p2.Ejer = v.Ejer and p2.NroCta = v.NroCta
left join Cliente2 c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt
left join Proveedor2 pr on pr.RucE = v.RucE and pr.Cd_Prv = v.Cd_Prv
where v.RucE = @RucE and v.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin and v.NroCta like '48%'
group by 
dbo.NivelCuenta(v.NroCta,2),
p.NomCta,
dbo.NivelCuenta(v.NroCta,3),
p1.NomCta,
v.NroCta,
p2.NomCta,
v.Cd_MdRg, 
v.Cd_Clt,
v.Cd_Prv,
case when v.Cd_MdRg = '01' then 'S/.' else 'US$.' end,
case when isnull(v.Cd_Clt,'') <> '' then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))
	 when isnull(v.Cd_Prv,'') <> '' then isnull(pr.RSocial,isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))
	 else '--Sin Auxiliar--' end
end
--<CREADO: JA><19/03/2013> 
--exec Rpt_InvBlc_Cta48 '20521620090','2012','01/01/2012','31/12/2012',null
GO

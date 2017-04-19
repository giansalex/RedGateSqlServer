SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteResum4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Prv char(7),--Modificado, antes era @Cd_Prv
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'
if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,Convert(varchar,@FechaAl,103) as FechaAl from Empresa where Ruc=@RucE
--select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
--if( @Cd_Mda = '01')
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
	select	
		v.RucE,	isnull(a.NDoc,'No identificado') as NDoc,
		isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
	and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
	and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and v.Cd_Prv=@Cd_Prv
	group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom
	
end
else
begin
	select	
		v.RucE,a.NDoc,
		isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
	and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
	and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
	group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom

end	
--print @msj

--MP: VIE 17-09-2010 --> Se quito la referencia a la tabla Auxiliar y se enlazo con Proveedor2
		     --> Se cambio el parametro @Cd_Aux a @Cd_Prv 
--CM: PR03
--CM: RA01


GO

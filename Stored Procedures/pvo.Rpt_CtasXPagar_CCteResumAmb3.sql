SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_CCteResumAmb3] 
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
--@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR 
		from Empresa where Ruc=@RucE

if(@Cd_Aux!='' and @Cd_Aux is not null)
--if not exists(select * from voucher where rucE=@RucE and ejer=@Ejer)
--set @msj='Error de Consulta'
	begin
		select v.RucE,	isnull(a.NDoc,'No identificado') as NDoc,
		isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,	
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
		and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and v.Cd_Aux=@Cd_Aux
		group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom
		having sum(v.MtoD)-sum(v.MtoH)<>0
		order by a.RSocial,a.ApPat,a.ApMat,a.Nom


	end
else
	begin
	
		select v.RucE,	isnull(a.NDoc,'No identificado') as NDoc,
		isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
		and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
		group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom
		having sum(v.MtoD)-sum(v.MtoH)<>0
		order by a.RSocial,a.ApPat,a.ApMat,a.Nom

	end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

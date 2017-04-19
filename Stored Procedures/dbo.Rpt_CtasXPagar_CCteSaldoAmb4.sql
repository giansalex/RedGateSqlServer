SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldoAmb4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
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

--if( @Cd_Aux= (select Cd_Aux from voucher where rucE=@RucE and Ejer=@Ejer and (left(NroCta,2)=12 or left(NroCta,2)=16) and Cd_Aux=@Cd_Aux))
if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
	select 	v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, 
	sum(v.MtoD) Debe, sum(v.MtoH) Haber,sum(v.MtoD_ME) Debe_ME,sum(v.MtoH_ME) Haber_ME,
	v.Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag='1'/*--(left(v.NroCta,2)=12 or left(v.NroCta,2)=16)*/ and v.Cd_Aux= @Cd_Aux and
	v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
	group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial
	order by v.Cd_TD,v.NroSre,v.NroDoc,NomAux,FecMov 
end
else
begin
select 	v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, 
	sum(v.MtoD) Debe, sum(v.MtoH) Haber,sum(v.MtoD_ME) Debe_ME,sum(v.MtoH_ME) Haber_ME,
	v.Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
--	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2)/*and a.cd_aux=@Cd_Aux*/ and p.IB_CtasXPag='1' /*(left(v.NroCta,2)=12 or left(v.NroCta,2)=16)*/ and 
	v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
	group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial
	order by v.Cd_TD,v.NroSre,v.NroDoc,NomAux,FecMov
end
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

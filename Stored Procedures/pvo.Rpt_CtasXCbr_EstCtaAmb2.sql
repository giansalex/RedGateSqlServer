SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCtaAmb2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
--@Cd_Aux nvarchar(7),
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
		select	v.NroCta, a.NDoc,RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,convert(varchar,v.FecMov,103) as FecED,
		convert(varchar,v.FecVD,103) as FecVD,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		/*sum(v.MtoD)Debe, sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH)Haber, sum(v.MtoH_ME) Haber_ME*/
		v.MtoD as Debe,v.MtoD_ME as Debe_ME,
		v.MtoH as Haber,v.MtoH_ME as Haber_ME
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.Cd_Aux= @Cd_Aux/*--*/ and v.IB_Anulado<>'1'/*--*/and v.FecMov <= @FechaAl
		--(left(v.NroCta,2)=12 or left(v.NroCta,2)=16) 
		order by v.Cd_Vou,v.NroCta,a.NDoc,FecED asc
		--group by v.RucE, v.NroCta,a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial
	end
else
	begin
		select	v.NroCta, a.NDoc,RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,convert(varchar,v.FecMov,103) as FecED,
		convert(varchar,v.FecVD,103) as FecVD,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		/*sum(v.MtoD)Debe, sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH)Haber, sum(v.MtoH_ME) Haber_ME*/
		v.MtoD as Debe,v.MtoD_ME as Debe_ME,
		v.MtoH as Haber,v.MtoH_ME as Haber_ME
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1/*--*/ and v.IB_Anulado<>'1'/*--*//*and v.Cd_Aux= @Cd_Aux*/
		and v.FecMov <= @FechaAl
		--(left(v.NroCta,2)=12 or left(v.NroCta,2)=16) 
		order by v.Cd_Vou,v.NroCta,a.NDoc,FecED asc
		--group by v.RucE, v.NroCta,a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial

	end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

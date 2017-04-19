SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteResum2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'
if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select  Ruc, Rsocial, @Ejer ejer,  case('01') when @Cd_Mda then @Cd_Mda 
	else @Cd_Mda end Moneda,'1' IB_ImpFR 
from Empresa where Ruc=@RucE

if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
 	select	/*v.NroCta,*/ a.NDoc,	
	case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	sum(v.MtoD)Debe, sum(v.MtoD_ME) Debe_ME,
	sum(v.MtoH)Haber, sum(v.MtoH_ME) Haber_ME
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag='1' and v.Cd_Aux= @Cd_Aux
	and v.IB_Anulado<>'1'and v.FecMov <= @FechaAl
	--(left(v.NroCta,2)=42 or left(v.NroCta,2)=46)
	group by v.RucE, /*v.NroCta,*/ a.NDoc, a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado
	having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom
end
else
begin
	select	/*v.NroCta,*/ a.NDoc,	
	case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	sum(v.MtoD)Debe, sum(v.MtoD_ME) Debe_ME,
	sum(v.MtoH)Haber, sum(v.MtoH_ME) Haber_ME
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag='1' --and v.Cd_Aux= @Cd_Aux
	and v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
	--(left(v.NroCta,2)=42 or left(v.NroCta,2)=46)
	group by v.RucE, /*v.NroCta,*/ a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado
	having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom

end	
------CODIGO DE MODIFICACION--------
--CM=MG01

--print @msj
/*
exec dbo.Rpt_CtasXPagar_CCteResum2 '11111111111','2009','','','','01',null
select * from voucher where ruce='11111111111' and Ejer='2009' and nrocta between '10' and '20'
*/
GO

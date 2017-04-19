SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResum2]
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
--select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
--if( @Cd_Mda = '01')
if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
	select	v.RucE,/*Max(v.NroCta) as NroCta,*/a.NDoc,
	case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	case(@Cd_Mda) when '01' then sum(v.MtoD) 
	else sum(v.MtoD_ME) end as Debe, 
	case(@Cd_Mda) when '01' then sum(v.MtoH) 
	else sum(v.MtoH_ME) end as Haber,
	@Cd_Mda as Moneda
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.Cd_Aux=@Cd_Aux/* and v.IB_Anulado<>'1'*/
	and v.FecMov <= @FechaAl
	group by /*v.NroCta,*/v.RucE/*,v.Cd_Aux*//*,v.NroSre,v.NroDoc*/, a.NDoc, a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado--,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME 
	--/**/having (((sum(MtoD)-sum(MtoH))<>'0') and ((sum(MtoD_ME)-sum(MtoH_ME))<>'0'))/**/
	having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom
	
end
else
begin
	select	v.RucE,/*Max(v.NroCta) as NroCta,*/a.NDoc,
	case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	case(@Cd_Mda) when '01' then sum(v.MtoD) 
	else sum(v.MtoD_ME) end as Debe, 
	case(@Cd_Mda) when '01' then sum(v.MtoH) 
	else sum(v.MtoH_ME) end as Haber,
	@Cd_Mda as Moneda
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.IB_Anulado<>'1'*/
	and v.FecMov <= @FechaAl
	group by /*v.NroCta,*/v.RucE/*,v.Cd_Aux*/, a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.IB_Anulado--,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME 
	--/**/having (((sum(MtoD)-sum(MtoH)) <>'0') and ((sum(MtoD_ME)-sum(MtoH_ME))<>'0'))/**/
	having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
	order by a.RSocial,a.ApPat,a.ApMat,a.Nom

end	
--print @msj

------CODIGO DE MODIFICACION--------
--CM=MG01
GO

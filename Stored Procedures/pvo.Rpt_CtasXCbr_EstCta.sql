SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--REPORTE DE ESTADO DE CUENTAS--
--exec pvo.Rpt_CtasXCbr_EstCta '11111111111','2009','10','16','01',null---CLT0001
--select * from voucher
--select * from auxiliar
--select * from voucher where rucE='20428875282'
--REPORTE RESUMIDO DE ESTADO DE CUENTAS--
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCta]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

select  Ruc, Rsocial, @Ejer ejer,  case('01') when @Cd_Mda then @Cd_Mda 
	else @Cd_Mda end Moneda,'1' IB_ImpFR 
from Empresa where Ruc=@RucE

if( @Cd_Mda = '01')
begin
 select	v.NroCta,a.NDoc,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	/*sum(v.MtoD)*/v.MtoD as Debe, /*sum(v.MtoH) Haber*/v.MtoH as Haber
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and (left(v.NroCta,2)=10 and left(v.NroCta,2)=16)
	--group by v.RucE, v.NroCta, a.NDoc, a.RSocial,a.ApPat,a.ApMat,a.Nom
end
else
begin
 select	v.NroCta,a.NDoc,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	/*sum(v.MtoD_ME)*/v.MtoD_Me as Debe,/*sum(v.MtoH_ME)*/ v.MtoH_ME as Haber
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and (left(v.NroCta,2)=10 or left(v.NroCta,2)=16)
	--group by v.RucE, v.NroCta, a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom

end

------CODIGO DE MODIFICACION--------
--CM=MG01
GO

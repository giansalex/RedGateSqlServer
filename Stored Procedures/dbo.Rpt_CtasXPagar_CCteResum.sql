SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec dbo.Rpt_CtasXCbr_CCteResum '11111111111','2009',''
exec dbo.Rpt_CtasXPagar_CCteResum '11111111111','2009',''
*/
--REPORTE RESUMIDO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteResum]
@RucE nvarchar(11),
@Ejer nvarchar(4),
--@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
--@FechaAl datetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

--declare @Cd_Mda nvarchar(2)
--set @Cd_Mda = '01'

select Rsocial, @Ejer ejer,  case('01') when @Cd_Mda then @Cd_Mda 
	else @Cd_Mda end Moneda,'1' IB_ImpFR 
from Empresa where Ruc=@RucE

if( @Cd_Mda = '01')
begin
 select	v.RucE, v.NroCta, 
	a.NDoc,	sum(v.MtoD) Debe, sum(v.MtoH) Haber
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46)
	group by v.RucE, v.NroCta,
	a.NDoc
end
else
begin
 select	v.RucE, v.NroCta,
	a.NDoc,
	sum(v.MtoD_ME) Debe, sum(v.MtoH_ME) Haber
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46)
	group by v.RucE, v.NroCta,
	a.NDoc

end	
------CODIGO DE MODIFICACION--------
--CM=MG01

--print @msj
GO

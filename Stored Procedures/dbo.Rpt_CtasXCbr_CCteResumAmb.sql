SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec dbo.Rpt_CtasXCbr_CCteResumAmb '11111111111','2009',null


*/
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResumAmb] 
@RucE nvarchar(11),
@Ejer nvarchar(4),
--@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
--@FechaAl datetime,
--@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if not exists(select * from voucher where rucE=@RucE and ejer=@Ejer)
	set @msj='Error de Consulta'
else
	begin
		
		select Rsocial, @Ejer ejer,'1' IB_ImpFR 
		from Empresa where Ruc=@RucE

		select	v.RucE, v.NroCta,a.NDoc,	
		case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH)Haber, sum(v.MtoH_ME) Haber_ME
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		where v.RucE=@RucE and 
	      	v.Ejer=@Ejer and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16)
		group by v.RucE, v.NroCta,a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial

	end
print @msj

------CODIGO DE MODIFICACION--------
--CM=MG01
GO

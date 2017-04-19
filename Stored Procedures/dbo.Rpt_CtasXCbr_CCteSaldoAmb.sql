SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*declare @RucE nvarchar(11)
set @RucE='11111111111'
declare @Ejer nvarchar(4)
set @Ejer='2009'
declare @Cd_Aux nvarchar(7)
set @Cd_Aux='CLT0510'
--select * from voucher where left(NroCta,2)=12
declare @FechaAl datetime
set @FechaAl = '30/06/2009'
*/

CREATE procedure [dbo].[Rpt_CtasXCbr_CCteSaldoAmb]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
--@Cd_Mda nvarchar(2),
@msj varchar(100) output
as


if( @Cd_Aux= (select Cd_Aux from voucher where rucE=@RucE and Ejer=@Ejer and (left(NroCta,2)=12 or left(NroCta,2)=16) and Cd_Aux=@Cd_Aux))
begin
	select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, 
	sum(v.MtoD) Debe, sum(v.MtoH) Haber,sum(v.MtoD_ME) Debe_ME,sum(v.MtoH_ME) Haber_ME,
	v.Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16) and v.Cd_Aux= @Cd_Aux
	group by v.RucE, a.NDoc, e.RSocial, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial 
end
else
begin
select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, 
	sum(v.MtoD) Debe, sum(v.MtoH) Haber,sum(v.MtoD_ME) Debe_ME,sum(v.MtoH_ME) Haber_ME,
	v.Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer /*and a.cd_aux=@Cd_Aux*/ and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16)
	group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial,e.RSocial 
end
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

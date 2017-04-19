SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*--REPORTE SALDOS
--select * from voucher where Cd_Aux='CLT0165' and ruce='11111111111'
declare @FechaAl datetime
set @FechaAl = '30/06/2009'

declare @Cd_Mda nvarchar(2)
set @Cd_Mda = '02'
declare @Cd_Aux nvarchar(7)
set @Cd_Aux='CLT0051'--null

--if(@Cd_Aux is not null and not exists(select Cd_Aux from voucher where rucE='11111111111' and Ejer='2009' and left(NroCta,2)=12 and Cd_Aux=@Cd_Aux)
--begin
 	--print  'No existe Aux'
--end

--else
--begin*/
--REPORTE SALDOS
/*
declare @FechaAl datetime
set @FechaAl = '30/06/2009'
--exec dbo.Rpt_CtasXCbr_CCteSaldo '11111111111','2009','', @FechaAl,'02',null
exec dbo.Rpt_CtasXPagar_CCteSaldo '11111111111','2009','', @FechaAl,'02',null
select * from auxiliar
select * from voucher where (left(NroCta,2)=42 or left(NroCta,2)=46)
--cambiar a cabecera y detalle
*/
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldo]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if( @Cd_Aux= (select Cd_Aux from voucher where rucE=@RucE and Ejer=@Ejer and (left(NroCta,2)=42 or left(NroCta,2)=46) and Cd_Aux=@Cd_Aux))
begin
if( @Cd_Mda = '01')
begin

select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD) Debe, sum(v.MtoH) Haber,
	@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46) and v.Cd_Aux= @Cd_Aux
	group by v.RucE,e.RSocial, v.NroCta, a.NDoc, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial 

end
else 
begin
select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD_ME) Debe, sum(v.MtoH_ME) Haber,
	@Cd_Mda as Cd_MdRg, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46) and v.Cd_Aux=@Cd_Aux
	group by v.RucE, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial,e.RSocial, a.NDoc 
end

end
else
begin
if( @Cd_Mda = '01')
begin
select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD) Debe, sum(v.MtoH) Haber,
	@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer /*and a.cd_aux=@Cd_Aux*/ and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46)
	group by v.RucE, v.NroCta, v.Cd_Aux, a.NDoc, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial,e.RSocial 
end
else 
begin
select 	v.RucE, v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD_ME) Debe, sum(v.MtoH_ME) Haber,
	@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
	e.Rsocial
	from voucher as v
	left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer /* and a.cd_aux=@Cd_Aux*/ and (left(v.NroCta,2)=42 or left(v.NroCta,2)=46) 
	group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial,e.RSocial
end
end
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

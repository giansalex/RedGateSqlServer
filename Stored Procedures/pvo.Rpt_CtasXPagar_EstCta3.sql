SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_EstCta3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE

--TABLA DETALLE
if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
		select 	a.NDoc as NDocAux, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, RegCtb, v.NroCta,
		v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecED, '' as FecVD, /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag='1' and v.Cd_Aux= @Cd_Aux and v.FecMov <= @FechaAl
		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, RegCtb, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc


end
else -- No tiene aux
begin
		select 	a.NDoc as NDocAux, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, RegCtb, v.NroCta,
		v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecED, '' as FecVD, /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag='1' /*and v.Cd_Aux= @Cd_Aux*/ and v.FecMov <= @FechaAl
		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, RegCtb, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc
end
------CODIGO DE MODIFICACION--------
--CM=MG01

--Pruebas:
--exec pvo.Rpt_CtasXPag_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null

--PV: VIE 05/06/2009 : CREADO
print @msj
GO

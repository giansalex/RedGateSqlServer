SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_CCteSaldo4]
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
		select 	a.NDoc as NDocAux, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
		Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc, 
		
		-- ANTES
		-- convert(varchar,v.FecED,103) as FecED, 
		-- v.FecVD as FecVD, /*v.FecVD,*/ 
		-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
				
		-- DESPUES (MEJORA)
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
		sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,  


		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.Cd_Aux= @Cd_Aux /*==*//*and v.IB_Anulado<>'1'*/ and /*==*/v.FecMov <= @FechaAl
		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ /*v.Cd_TD,*/ /*v.NroSre,*//* v.NroDoc,*/v.IB_Anulado--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc


end
else -- No tiene aux
begin
		select 	a.NDoc as NDocAux, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
		Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
		
		-- ANTES
		-- convert(varchar,v.FecED,103) as FecED, 
		-- v.FecVD as FecVD, /*v.FecVD,*/ 
		-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
				
		-- DESPUES (MEJORA)
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
		sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,  


		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ and v.FecMov <= @FechaAl
		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ /*v.Cd_TD,*/ /*v.NroSre,*//* v.NroDoc,*/v.IB_Anulado --, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(v.MtoD)-sum(v.MtoH)<>0 and v.IB_Anulado<>'1'
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc
end

------CODIGO DE MODIFICACION--------
--CM=MG01

--Pruebas:
--exec pvo.Rpt_CtasXPagar_CCteSaldo3 '11111111111','2009','','','','','01',null
--select * from voucher where ruce='11111111111' and nrodoc='121212'
--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
print @msj
GO

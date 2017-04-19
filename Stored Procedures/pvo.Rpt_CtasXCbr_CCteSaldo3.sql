SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_CCteSaldo3]
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
		v.Cd_TD, v.NroSre, v.NroDoc, 
		
		-- ANTES
		-- convert(varchar,v.FecED,103) as FecED, 
		-- v.FecVD as FecVD, /*v.FecVD,*/ 
		-- datediff(day,v.FecVD,@FechaAl) as Saldo_Dias,  
				
		-- DESPUES (MEJORA)
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, --else '00/00/0000' end) as FecED, 
		Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, --else '00/00/0000' end) as FecVD, 
		sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,  
		
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.Cd_Aux= @Cd_Aux and v.FecMov <= @FechaAl
		group by v.NroDoc,a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD, v.NroSre, v.NroDoc --, convert(varchar,v.FecED,103), v.FecVD, datediff(day,v.FecVD,@FechaAl) --,v.Cd_MdRg
		order by a.NDoc, NomAux, v.Cd_TD, v.NroSre, v.NroDoc


end
else -- No tiene aux
begin
		select 	a.NDoc as NDocAux, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
		v.Cd_TD, v.NroSre, v.NroDoc, 

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
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*/ and v.FecMov <= @FechaAl 
		group by v.NroDoc,a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD, v.NroSre, v.NroDoc --, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		order by a.NDoc, NomAux, v.Cd_TD, v.NroSre, v.NroDoc
end

--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','CLT0220','','','05/02/2009','01',null

--select * from auxiliar where ndoc='20101996973' --Promotora...
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','CLT0030','','','03/07/2009','01',null
--select * from voucher where ruce='11111111111' and nroDoc='100200'



--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias

------CODIGO DE MODIFICACION--------
--CM=MG01

print @msj
GO

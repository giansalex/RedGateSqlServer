SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_EstCta7]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
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
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,Convert(varchar,@FechaAl,103) as FechaAl from Empresa where Ruc=@RucE

--TABLA DETALLE
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
		select 	
			isnull(a.NDoc,'No identificado') as NDocAux, 
			isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			and v.Cd_Prv= @Cd_Prv /*v.Cd_Aux= @Cd_Aux*/ and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
			and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
			/*and v.NroDoc not in 
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
				       sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
			)*/

		group by 
			a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov--,v.Cd_MdRg
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov

end
else -- No tiene aux
begin
		select 	
			isnull(a.NDoc,'No identificado') as NDocAux, 
			isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			/*and v.Cd_Aux= @Cd_Aux*/ and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
			and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
			/*and v.NroDoc not in
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 --and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
				       sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
			)*/

		group by 
			a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov--,v.Cd_MdRg
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov

end
--Pruebas:
--exec pvo.Rpt_CtasXPagar_EstCta7 '11111111111','2009','','','','05/02/2009','01',null
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
--JS: LUN 19/07/2010 : MODF: se agrego para que muestre la mda. rg.

--MP: DOM 19-09-2010 : Modf: Se quito las referencias a la tabla Auxiliar  se enlazon con Proveedor2
--CM=PR03
--CM=RA01
GO

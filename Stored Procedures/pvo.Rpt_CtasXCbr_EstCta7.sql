SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCta7]
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
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,Convert(varchar,@FechaAl,103) as FechaAl from Empresa where Ruc=@RucE

--TABLA DETALLE

if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
print 'Tiene Aux'
--PRINT datediff(second,v.FecMov,@FechaAl)

		select 	
			isnull(a.NDoc,'No identificado') as NDocAux, 
			isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,

			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/
		convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial,
			 v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,datediff(day,v.FecMov,@FechaAl)
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by v.FecMov--,a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc	

 
end
else -- No tiene aux
begin
		select 	
			isnull(a.NDoc,'No identificado') as NDocAux, 
			isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  
			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial,
			 v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,datediff(day,v.FecMov,@FechaAl)
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by v.FecMov--,a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc
end

--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
--Ejemplos
/*exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
exec pvo.Rpt_CtasXCbr_EstCta5 '20513272848','2009','AUX0490','12.1.0.01','12.1.0.01','30/11/2009','01',null
exec pvo.Rpt_CtasXCbr_EstCta5 '20513272848','2009','AUX0490','12.1.0.01','12.1.0.01','01/12/2009','01',null
2009-11-30 14:34:00 <= 2009-11-30 00:00:00
DECLARE @FechaAl smalldatetime
--SET @FechaAl = CONVERT(smalldatetime,'30/11/2009 14:33:00')
SET @FechaAl = CONVERT(smalldatetime,'01/10/2009')
PRINT @FechaAl

--SELECT * FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
SELECT datediff(day,FecMov,@FechaAl) FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'

datediff(day,FecMov,@FechaAl) >=0

-----------------
DECLARE @FechaAl smalldatetime
SET @FechaAl = CONVERT(smalldatetime,'30/11/2009 14:33:00')
PRINT @FechaAl
print convert(varchar,@FechaAl,102)
convert(varchar,@FecMov,102) <= convert(varchar,@FechaAl,102)
25072009 <= 20112009
2009.07.25 <= 2009.12.20
--SELECT * FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
SELECT datediff(second,FecMov,@FechaAl) FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
datediff(second,FecMov,@FechaAl) >=0
PRINT datediff(second,v.FecMov,@FechaAl)*/


--LEYENDA--
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)

------CODIGO DE MODIFICACION--------
--CM=MG01

print @msj
GO

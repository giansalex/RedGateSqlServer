SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCta6]
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

/*select * from empresa where RSocial like '%CONTA%'
select * from auxiliar where NDoc='20109714039' and RucE='20512635025'

Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @Cd_Aux nvarchar(7)
Declare @NroCta1 nvarchar(10)
Declare @NroCta2 nvarchar(10)
Declare @FechaAl smalldatetime
Declare @Cd_Mda nvarchar(2)

Set @RucE='20512635025'
Set @Ejer='2009'
Set @Cd_Aux=''--'CLT0109'
Set @NroCta1=''
Set @NroCta2=''
Set @FechaAl='31/12/2009'
Set @Cd_Mda='01'*/

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE

--TABLA DETALLE

if(@Cd_Aux!='' and @Cd_Aux is not null)
begin
		select 	
			isnull(a.NDoc,'No identificado') as NDocAux, 
			isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			and v.Cd_Aux= @Cd_Aux and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
		/*	and v.NroDoc not in 
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
				       sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
			)
		*/
		group by 
			a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov
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
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
			case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
			@Cd_Mda as Cd_MdRg --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			/*and v.Cd_Aux= @Cd_Aux*/ and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
			/*and v.NroDoc not in
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 --and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
				       sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
			)*/

		group by 
			a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by v.FecMov--,a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc

end
------CODIGO DE MODIFICACION--------
--CM=MG01

--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
GO

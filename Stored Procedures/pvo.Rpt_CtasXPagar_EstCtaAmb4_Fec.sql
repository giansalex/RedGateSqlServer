SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_EstCtaAmb4_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

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
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE
--TABLA DETALLE
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
		select 	
			--isnull(a.NDoc,'No identificado') as NDoc, 
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
	
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,	
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,


			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaFin) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			and v.Cd_Prv= @Cd_Prv/*v.Cd_Aux= @Cd_Aux*/ and 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102)
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
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,c.NDoc,v.Cd_Prv,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,c.RSocial
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by pr.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov

end
else -- No tiene aux
begin
		select 	
			--isnull(a.NDoc,'No identificado') as NDoc, 
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,

			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,	
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,

			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaFin) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			/*and v.Cd_Aux= @Cd_Aux*/ and 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102)
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
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,c.NDoc,v.Cd_Prv,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,c.RSocial
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		order by pr.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov

end
--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
--Jesus -> Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--Ejemplo
--exec  pvo.Rpt_CtasXPagar_EstCtaAmb4_Fec '11111111111','2010','','','','01/01/2010','01/12/2010',null

--MP: DOM 19-09-2010 Modf: Se quito las referencias a la tabla Auxiliar y se enlazo con Proveedor2
--CM: PR03
--CM: RA01
print @msj
GO

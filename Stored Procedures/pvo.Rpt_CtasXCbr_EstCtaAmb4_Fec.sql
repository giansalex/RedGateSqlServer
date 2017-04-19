SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [pvo].[Rpt_CtasXCbr_EstCtaAmb4_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),--<<-- Cambio de parametro
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
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
		select 	
			-- isnull(a.NDoc,'No identificado') as NDoc, --<<-- Modificado en linea 44
			--isnull(c.NDoc,'No identificado') as NDoc,--<<-- Nueva
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,

			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en linea 46
			--isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux,

			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,	

			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		-- left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en la linea 55
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer

		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and v.Cd_Clt = @Cd_Clt and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102)and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		

		/*where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			and v.Cd_Aux= @Cd_Aux and v.FecMov <= @FechaAl 
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
			and v.NroDoc not in 
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			-- a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial, --<<-- Modificado en linea 84
			c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial, --<<-- Nueva
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		-- order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Modificado en linea 88
		order by c.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Nueva

end
else -- No tiene aux
begin
		select 	
			-- isnull(a.NDoc,'No identificado') as NDoc, --<<-- Modificado en linea 95
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,

			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,--<<-- Modificado en linea 97
			--isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux,--<<--Nueva
			
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,	

			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb
			,v.NroCta
			,isnull(v.Cd_TD,'') as Cd_TD
			,isnull(v.NroSre,'') as NroSre
			,isnull(v.NroDoc,'') as NroDoc
			--,isnull(v.Cd_TD,'')+' '+isnull(v.NroSre,'')+ '-' + isnull(v.NroDoc,'') as NroDoc
			, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux--<<--Modificado en linea 106
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		

		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102)and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


		--where 	
			--v.RucE=@RucE and v.Ejer=@Ejer 
			--and (v.NroCta between @NroCta1 and @NroCta2) 
			/*and v.Cd_Aux= @Cd_Aux*/ --and v.FecMov <= @FechaAl 
			--and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
			/*and v.NroDoc not in
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 --and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			--a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial,--<<-- Modificado en linea 136
			c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial,--<<-- Nueva
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		--order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Modificado en linea 140
		order by c.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Nueva

end
--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
--Jesus -> Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--Ejemplo
--exec  pvo.Rpt_CtasXCbr_EstCtaAmb4_Fec '11111111111','2010','','','','01/01/2010','01/12/2010',null
--exec  pvo.Rpt_CtasXCbr_EstCtaAmb4_Fec '20512141022','2011','','','','01/01/2011','01/12/2011',null
--CAM VIE 17/09/2010 Modificado PR03 RA01:
--					Quito tabla Auxiliar
--					Agrego la tabla Cliente2
--					Se cambio el parametro @Cd_Aux por @Cd_Clt

print @msj
GO

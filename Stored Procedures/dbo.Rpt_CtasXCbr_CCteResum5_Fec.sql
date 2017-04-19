SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResum5_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select  Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR ,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha
from Empresa where Ruc=@RucE
--select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
--if( @Cd_Mda = '01')
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
	select 	NDocAux,NomAux, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Max(Moneda) Moneda
		from(
	select	
		--isnull(a.NDoc,'No identificado') as NDocAux, --<<-- Modificado en Linea 29
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,--<<-- Modificado en Linea 30
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,--<<-- ya estaba comentado
		--isnull(c.NDoc,'No Identificado') as NDocAux,--<<-- Nueva Linea
		--IsNull(c.NDoc,pr.NDoc) as NDocAux,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin InformaciÃ³n---') as NDocAux,
		--isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux,--<<-- Nueva Linea
		--IsNull(c.RSocial,pr.RSocial) as NomAux,
		
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
		


		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda--,
		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en Linea 39
	left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	left join Empresa as e on e.Ruc=v.RucE

	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
	and v.Cd_Clt = @Cd_Clt and /*(v.FecMov <= @FechaAl)*/ 
	convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
	and convert(varchar,@FechaFin,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

	/*where v.RucE=@RucE and 
	v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and 
	p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and 
	v.FecMov <= @FechaAl and v.Cd_Aux=@Cd_Aux*/
	-- group by a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg -- <<-- Modificado en Linea 57
	group by c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom--,v.Cd_MdRg --<<-- Nueva
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	--order by c.RSocial,c.ApPat,c.ApMat,c.Nom --<<-- Modificado en Linea 60
	--order by c.RSocial,c.ApPat,c.ApMat,c.Nom --<<-- Nueva
	) as Con1
	group by NDocAux,NomAux
	order by NomAux --<<-- Nueva

	
end
else
begin
	select 	NDocAux,NomAux, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Max(Moneda) Moneda
		from(
	select	
		--isnull(a.NDoc,'No identificado') as NDocAux,--<<-- Modificado en Linea 68
		--isnull(c.NDoc,'No identificado') as NDocAux, --<<-- Nueva Linea
		--IsNull(c.NDoc,pr.NDoc) as NDocAux,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin InformaciÃ³n---') as NDocAux,
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en Linea 70
		--isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva Linea
		--IsNull(c.RSocial,pr.RSocial) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
				
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then null
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
		
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda--,
		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en Linea 80
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva Linea
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----	
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and  
	/*(v.FecMov <= @FechaAl)*/ 
	convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
	and convert(varchar,@FechaFin,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


	--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
	--group by a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg --<<-- Modificado en Linea 94
	--group by c.NDoc,c.RSocial,pr.NDoc,pr.RSocial--,c.ApPat,c.ApMat,c.Nom,v.Cd_MdRg
	group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	--order by a.RSocial,a.ApPat,a.ApMat,a.Nom --<<-- Modificado en Linea 97
	--order by c.RSocial,c.ApPat,c.ApMat,c.Nom
	) as Con2
	group by NDocAux,NomAux
	order by NomAux--<<-- Nueva

end	
print @msj
/*
Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--Ejemplo : 
--exec Rpt_CtasXCbr_CCteResum5_Fec '11111111111','2010','','','','01/12/2010','31/12/2010','01',null
*/
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
--CAM: VIE 17/09/2010 Modificado PR03 RA01: 
--				Eliminacion de la tabla Auxiliar. 
--				Se agrego la tabla Cliente2
--				Se cambio el parametro @Cd_Aux por @Cd_Clt(char 10)

GO

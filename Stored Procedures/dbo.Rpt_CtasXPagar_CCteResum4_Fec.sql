SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteResum4_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
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

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE
--select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
--if( @Cd_Mda = '01')
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
	select	
		v.RucE,	
		--isnull(a.NDoc,'No identificado') as NDoc,
		--IsNull(c.NDoc,pr.NDoc) as NDoc,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
				


		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
	left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
	and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
	and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
	and v.Cd_Prv=@Cd_Prv
	--group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom
	group by v.RucE,c.NDoc,c.RSocial,pr.RSocial,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by c.RSocial,c.ApPat,c.ApMat,c.Nom
	
end
else
begin
	select	
		v.RucE,
		--a.NDoc,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then null
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
				
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
	left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and 
	convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
	and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
	group by v.RucE,c.NDoc,c.RSocial,pr.RSocial,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by c.RSocial,c.ApPat,c.ApMat,c.Nom

end	
--print @msj
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--exec dbo.Rpt_CtasXPagar_CCteResum4_Fec '11111111111','2010','','','','01/01/2010','01/12/2010','01',null
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas

--MP: VIE 17-09-2010 --> Se quito las referencias a la tabla Auxiliar y se enlazo con Proveedor2
		     --> Se modifico un parametro de @Cd_Aux a @Cd_Prov
--CM: PR03
--CM: RA01
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResumAmb4_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),--Se cambio en nombre, antes era @Cd_Aux
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'


select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

if(@Cd_Clt!='' and @Cd_Clt is not null)
--if not exists(select * from voucher where rucE=@RucE and ejer=@Ejer)
--set @msj='Error de Consulta'
	begin
		select NDocAux,NomAux,Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(Debe_ME) Debe_ME, Sum(Haber_ME) Haber_ME, Sum(Saldo_ME) Saldo_ME
		from(
		select 
		--isnull(a.NDoc,'No identificado') as NDocAux,
		--IsNull(c.NDoc,pr.NDoc) as NDocAux,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Informacion---') as NDocAux,
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,	
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,		
		
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
	
		left join Empresa as e on e.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv= v.RucE
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt= @Cd_Clt 
		and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
		and convert(varchar,@FechaFin,102)
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		
		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and v.FecMov <= @FechaAl and v.Cd_Aux=@Cd_Aux
		--group by v.RucE,c.NDoc,c.RSocial,c.ApPat,c.ApMat,c.Nom,pr.NDoc,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.Nom,pr.RSocial,v.Cd_Clt,pr.NDoc
		group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by c.RSocial,c.ApPat,c.ApMat,c.Nom
		) as Con1
		group by NDocAux,NomAux
		order by NomAux

	end
else
	begin
		select NDocAux,NomAux,Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(Debe_ME) Debe_ME, Sum(Haber_ME) Haber_ME, Sum(Saldo_ME) Saldo_ME
		from(
		select 
		--isnull(a.NDoc,'No identificado') as NDocAux,
		--IsNull(c.NDoc,pr.NDoc) as NDocAux,
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Informacion---') as NDocAux,
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then null
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v

		left join Empresa as e on e.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv= v.RucE
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and 
		/*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
		and convert(varchar,@FechaFin,102)
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		

		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
		--group by v.RucE,c.NDoc,c.RSocial,c.ApPat,c.ApMat,v.Cd_Clt,c.Nom,pr.NDoc,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial
		group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by c.RSocial,c.ApPat,c.ApMat,c.Nom
	) as con2 
	group by NDocAux,NomAux
	order by NomAux

	end
print @msj
/*
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--exec Rpt_CtasXCbr_CCteResumAmb4_Fec '11111111111','2010','','','','01/12/2010','31/12/2010',null
*/

--DEMO
--exec Rpt_CtasXCbr_CCteResumAmb4_Fec '11111111111','2010','','','CLT0000002','01/01/2010','01/12/2010',null
--MP: VIE 17-09-2010 --> Se quito las referencia a la tabla auxiliar y se enlazo con Cliente2
		         --> Se cambio la variable Cd_Aux a Cd_Clt
--CM: PR03
--CM: RA01

GO

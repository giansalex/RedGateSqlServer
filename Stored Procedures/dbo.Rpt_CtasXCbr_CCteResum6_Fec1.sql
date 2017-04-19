SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResum6_Fec1]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),
@FechaIni datetime,
@FechaFin datetime,
@PrdoI varchar(2),
@PrdoF varchar(2),
@Cd_Mda nvarchar(2),
@IB_VerSaldados bit,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF
--exec pruebaJuJo '11111111111','2010','','','','01/12/2010','31/12/2010',null,'','01',1,null
declare @Cond varchar(200)
declare @Cond1 varchar(200)
set @Cond=''
set @Cond1=''

--if(@NroCta1='' or @NroCta1 is null)
--set @NroCta1 = '00'

--if(@NroCta2='' or @NroCta2 is null)
--set @NroCta2 = '99'
--declare @VarNum decimal(8,5)
--set @VarNum = 0.00
--if @IB_VerSaldados = 1
--begin
--	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
--end
if(@PrdoI <>'' or @PrdoI is not null)
begin
set @Cond=' and v.Prdo between '''+Convert(varchar,@PrdoI) +''' and '''+ convert(varchar,@PrdoF)+''' '
set @Cond1='''Del :' +Convert(varchar,@PrdoI)+ ' Al :' + Convert(varchar,@PrdoF)+''' '
end
else 
begin
set @Cond=' and Convert(varchar,v.FecMov,103) between '''+Convert(varchar,@FechaIni,103)+''' and '''+Convert(varchar,@FechaFin,103)+''' '
set @Cond1='''Del : ' + Convert(varchar,@FechaIni,103)+ ' Al : ' + Convert(varchar,@FechaFin,103)+''' '
end
print @Cond1
declare @Consulta varchar(8000)
set @Consulta=''
--print @Consulta


set @Consulta='
select  Ruc, Rsocial, '''+@Ejer+''' ejer,''1'' IB_ImpFR ,'+@Cond1+' as Fecha
from Empresa where Ruc='''+@RucE+''' '
/*
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
set @Consulta = @Consulta + '
	select 	NDocAux,NomAux, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Max(Moneda) Moneda
		from(
	select	
		COALESCE(IsNull(c.NDoc,pr.NDoc),''---Sin Informacion---'') as NDocAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then ''----''
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +'' ''+pr.ApMat+'' ''+pr.Nom,''''),''------- SIN NOMBRE ------'') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'' ''+c.Nom,''''),''------- SIN NOMBRE ------'') else c.RSocial end 
		end 
		as NomAux,
		case('''+@Cd_Mda+''') when ''01'' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case('''+@Cd_Mda+''') when ''01'' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		'''+@Cd_Mda+''' as Moneda
	from voucher as v
	left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	left join Empresa as e on e.Ruc=v.RucE

	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and (v.NroCta between '''+@NroCta1+''' and '''+@NroCta2+''') 
	and v.Cd_Clt = '''+@Cd_Clt+''' 
	'+@Cond+'
	and p.IB_CtasXCbr=1 and v.IB_Anulado<>''1''
	group by c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom--,v.Cd_MdRg --<<-- Nueva
	having sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end) - sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end) + '''+convert(varchar,@VarNum)+''' <> 0
	) as Con1
	group by NDocAux,NomAux
	order by NomAux --<<-- Nueva
'
print @Consulta
end
else
begin
set @Consulta= @Consulta+'
	select 	NDocAux,NomAux, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Max(Moneda) Moneda
		from(
	select	
		COALESCE(IsNull(c.NDoc,pr.NDoc),''---Sin Informacion---'') as NDocAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then null
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +'' ''+pr.ApMat+'' ''+pr.Nom,''''),''------- SIN NOMBRE ------'') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'' ''+c.Nom,''''),''------- SIN NOMBRE ------'') else c.RSocial end 
		end 
		as NomAux,
		
		case('''+@Cd_Mda+''') when ''01'' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case('''+@Cd_Mda+''') when ''01'' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		'''+@Cd_Mda+''' as Moneda
	from voucher as v
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva Linea
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and (v.NroCta between '''+@NroCta1+''' and '''+@NroCta2+''') 
	'+@Cond+'
	and p.IB_CtasXCbr=1 and v.IB_Anulado<>''1''
	--and p.IB_CtasXCbr=1 and v.IB_Anulado<>''1''

	group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
	having sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end) - sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end) + '''+convert(varchar,@VarNum)+'''<> 0
	) as Con2
	group by NDocAux,NomAux
	order by NomAux--<<-- Nueva
'
end


print @Consulta
	

*/

--print @Consulta
exec (@Consulta)
print @msj

Select 
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End As NomAux,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	@Cd_Mda as Moneda
	--,isnull(g.IB_Saldado,0) As IB_Saldado
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
		and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End)-Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)=0
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and isnull(v.IB_Anulado,0)<>1
	and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
	and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
	and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
	and Case When isnull(@Cd_Clt,'')<>'' Then v.Cd_Clt Else '' End =isnull(@Cd_Clt,'')
Group by 
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End,
	g.IB_Saldado

Having
	isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0)<>1
	and Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<>0
	
Order by NomAux

/*
Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--Ejemplo : 
exec pruebaJuJo '11111111111','2010','','','','01/12/2010','31/12/2010','','','01',1,null
*/
--JJ:  JUE 07/04/2011 -- Creacion del sp
GO

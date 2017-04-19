SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteResum5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@FechaIni datetime,
@FechaFin datetime,
@PrdoI varchar(2),
@PrdoF varchar(2),
@Cd_Mda nvarchar(2),
@CD_TipProv nvarchar(3),
@msj varchar(100) output
as

--declare @RucE nvarchar(11)
--declare @Ejer nvarchar(4)
--declare @NroCta1 nvarchar(10)
--declare @NroCta2 nvarchar(10)
--declare @Cd_Prv char(7)--Modificado, antes era @Cd_Aux nvarchar(7)
--declare @FechaIni datetime
--declare @FechaFin datetime
--declare @PrdoI varchar(2)
--declare @PrdoF varchar(2)
--declare @Cd_Mda nvarchar(2)
--declare @CD_TipProv nvarchar(3)
--declare @msj varchar(100)

--set @RucE = '11111111111'
--set @Ejer = '2010'
--set @NroCta1 =''
--set @NroCta2 =''
--set @Cd_Prv =''--Modificado, antes era @Cd_Aux nvarchar(7)
--set @FechaIni ='01/01/2010'
--set @FechaFin ='31/12/2010'
--set @PrdoI = '05'
--set @PrdoF ='05'
--set @Cd_Mda ='01'
--set @CD_TipProv =''
--set @msj =''



declare @Cond varchar(200)
declare @Cond1 varchar(200)
set @Cond=''
set @Cond1=''
--if(@NroCta1='' or @NroCta1 is null)
--set @NroCta1 = '00'
--if(@NroCta2='' or @NroCta2 is null)
--set @NroCta2 = '99'
if(@PrdoI<>'' or @PrdoI is not null)
begin
set @Cond=' and v.Prdo between '''+@PrdoI+''' and '''+@PrdoF+''' '
set @Cond1='''Del : ' +Convert(varchar,@PrdoI)+ ' Al : '+Convert(varchar,@PrdoF)+''' '
end
else
begin
--set @Cond=' and convert(nvarchar,v.FecMov,103) between convert(nvarchar,'''+@FechaIni+''',103) and convert(nvarchar,'''+@FechaFin+''',103)'''
set @Cond=' and Convert(varchar,v.FecMov,103) between '''+Convert(varchar,@FechaIni,103) +''' and '''+ Convert(varchar,@FechaFin,103)+''' '
set @Cond1='''Del: '+Convert(varchar,@FechaIni,103)+' Al: '+Convert(varchar,@FechaFin,103)+''' '
end

declare @Consulta varchar(8000)

set @Consulta='
select Ruc, Rsocial, '''+@Ejer+''' ejer,''1'' IB_ImpFR,'+@Cond1+' as Fecha from Empresa where Ruc='''+@RucE+''' '
/*
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
set @Consulta=@Consulta+'
      select      
            v.RucE,     
            COALESCE(IsNull(c.NDoc,pr.NDoc),''---Sin Información---'') as NDoc,
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
      left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
      left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
      where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and (v.NroCta between '''+@NroCta1+''' and '''+@NroCta2+''')
      '+@Cond+'
      and p.IB_CtasXPag=1 and v.IB_Anulado<>''1'' and v.Cd_Prv='''+@Cd_Prv+'''
      group by v.RucE,c.NDoc,c.RSocial,pr.RSocial,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom
      having sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end)-sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end)<>0
      order by c.RSocial,c.ApPat,c.ApMat,c.Nom
     ' 
end
else
begin
 set @Consulta= @Consulta+ '
      select      
            v.RucE,
            COALESCE(IsNull(c.NDoc,pr.NDoc),''---Sin Información---'') as NDoc,
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
      left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
      left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
      left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
      
      where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and (v.NroCta between '''+@NroCta1+''' and '''+@NroCta2+''') 
      '+@Cond+'
      and p.IB_CtasXPag=1 and v.IB_Anulado<>''1'' 
      group by v.RucE,c.NDoc,c.RSocial,pr.RSocial,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom
      having sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoD) else (v.MtoD_ME) end)-sum(case('''+@Cd_Mda+''') when ''01'' then (v.MtoH) else (v.MtoH_ME) end)<>0
      order by c.RSocial,c.ApPat,c.ApMat,c.Nom
'
end
print @Cond
print  @Cond1
PRINT @Consulta
exec(@Consulta)
*/
PRINT @Consulta
exec(@Consulta)

select 
	Max(RucE) As RucE,
	NDoc,
	NomAux,
	Sum(Debe) As Debe,
	Sum(Haber) As Haber,
	Sum(Saldo) As Saldo,
	Max(Moneda) As Moneda
from(
	Select 
		v.RucE,
		isnull(c.NDoc,isnull(r.NDoc,'')) As NDoc,
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
		Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Left Join 
		(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
			From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
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
		and Case When isnull(@Cd_Prv,'')<>'' Then v.Cd_Prv Else '' End =isnull(@Cd_Prv,'')
		and case when ISNULL(@CD_TipProv,'')<>'' then r.Cd_TPrv else '' end = ISNULL(@CD_TipProv,'')
	Group by 
		v.RucE,
		isnull(c.NDoc,isnull(r.NDoc,'')),
		Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																										   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																		 End 							  
		End--,
		--g.IB_Saldado

	Having
		sum(isnull(g.IB_Saldado,0))=0
		and Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<>0
) as Con
Group By NDoc, NomAux
Order by NomAux

--print @msj
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
--MP: VIE 17-09-2010 --> Se quito las referencias a la tabla Auxiliar y se enlazo con Proveedor2
	                 --> Se modifico un parametro de @Cd_Aux a @Cd_Prov
--CM: PR03
--CM: RA01
--exec Rpt_CtasXPagar_CCteResum5 '11111111111','2010', ''     ,'','','01/01/2010','31/12/2010','05','05','01','',null
GO

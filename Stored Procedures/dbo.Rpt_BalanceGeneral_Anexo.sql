SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_BalanceGeneral_Anexo]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Cd_Blc varchar(40),
@Cd_Mda nvarchar(2),
@n1 bit,
@n2 bit,
@n3 bit,
@n4 bit,
@MosDet bit,

@msj varchar(100) output

AS


Declare @Mda varchar(3) Set @Mda=''
if(@Cd_Mda = '02') Set @Mda='_ME'


DECLARE @sql0 varchar(8000) Set @sql0=''
DECLARE @sql1 varchar(8000) Set @sql1=''
DECLARE @sql2 varchar(8000) Set @sql2=''
DECLARE @sql3 varchar(8000) Set @sql3=''
DECLARE @sql4 varchar(8000) Set @sql4=''
DECLARE @sql5_1 varchar(8000) Set @sql5_1=''
DECLARE @sql5_2 varchar(8000) Set @sql5_2=''

Set @sql0=
	'
	Select 0 as Num,0 As Sub,r.Codigo,r.NroCta,p.Descrip As NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
		,Total4,Total3,Total2,Total1
	From (
		Select 
			a.RucE,a.Ejer,b.Cd_Blc As Codigo,'''' as NroCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,0.00 as Saldo
			,0.00 as Total4,0.00 as Total3,0.00 as Total2,
			Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') As Total1
		from Voucher a 
			Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(b.Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
		Group by 
			a.RucE,a.Ejer,b.Cd_Blc
		having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		) As r
		Left Join RubrosRpt p On p.Cd_Rb=r.Codigo
	'

if(@n1 = 1)
Begin
Set @sql1=
	'
	
	UNION ALL

	Select 1 as Num,0 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
		,Total4,Total3,Total2,Total1
	From (
		Select 
			a.RucE,a.Ejer,b.Cd_Blc As Codigo,left(a.NroCta,2) as NroCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,0.00 as Saldo
			,0.00 as Total4,0.00 as Total3,0.00 as Total2,
			Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') As Total1
		from Voucher a 
			Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
		Group by 
			a.RucE,a.Ejer,left(a.NroCta,2),b.Cd_Blc
		having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		) As r
		Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
End		

if(@n2 = 1)
Begin
Set @sql2=
	'	
	
	UNION ALL

	Select 2 as Num,0 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
		,Total4,Total3,Total2,Total1
	From (
		Select 
			a.RucE,a.Ejer,b.Cd_Blc As Codigo,left(a.NroCta,4) as NroCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,0.00 as Saldo
			,0.00 as Total4,0.00 as Total3,Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') as Total2,0.00 As Total1
		from Voucher a 
			Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
		Group by 
			a.RucE,a.Ejer,left(a.NroCta,4),b.Cd_Blc
		having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		) As r
		Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
End

if(@n3 = 1)
Begin
Set @sql3=
	'	
	
	UNION ALL

	Select 3 as Num,0 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
		,Total4,Total3,Total2,Total1
	From (
		Select 
			a.RucE,a.Ejer,b.Cd_Blc As Codigo,left(a.NroCta,6) as NroCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,0.00 as Saldo
			,0.00 as Total4,Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') as Total3,0.00 as Total2,0.00 As Total1
		from Voucher a 
			Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
		Group by 
			a.RucE,a.Ejer,left(a.NroCta,6),b.Cd_Blc
		having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		) As r
		Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
End

if(@n4 = 1)
Begin
Set @sql4=
	'	
	
	UNION ALL

	Select 4 as Num,0 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
		,Total4,Total3,Total2,Total1
	From (
		Select 
			a.RucE,a.Ejer,b.Cd_Blc As Codigo,a.NroCta as NroCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,0.00 as Saldo
			,Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') as Total4,0.00 as Total3,0.00 as Total2,0.00 As Total1
		from Voucher a 
			Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
		Group by 
			a.RucE,a.Ejer,a.NroCta,b.Cd_Blc
		having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		) As r
		Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
End


if(@MosDet = 1)
Begin

Set @sql5_1=
	'
UNION ALL
	
Select 5 as Num,1 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
	,Total4,Total3,Total2,Total1
From (
	Select 
		a.RucE,a.Ejer,b.Cd_Blc As Codigo,a.NroCta as NroCta,
		case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.Cd_Prv,''-'') else isnull(c.Cd_Clt,''-'') end as Cd_Aux,
		case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end As Cd_TDI,
		case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.NDoc,''-'') else isnull(c.NDoc,''-'') end As NDocAux,
		'' -TOTAL --> ''+case(isnull(len(a.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
        	 when 0 then isnull(nullif(p.ApPat +'' ''+p.ApMat+'', ''+p.Nom,''''),''------- SIN NOMBRE ------'')
        	 else p.RSocial  end  else case(isnull(len(c.RSocial),0)) 
       		 when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'', ''+c.Nom,''''),''------- SIN NOMBRE ------'')
        	 else c.RSocial end end as NomAux,
		'''' as Cd_TD,
		'''' as NroSre,
		'''' as NroDoc,
		Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') as Saldo
		,0.00 as Total4,0.00 as Total3,0.00 as Total2,0.00 As Total1
	from Voucher a 
		Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		left join proveedor2 p on p.RucE=a.RucE and p.Cd_Prv=a.Cd_Prv
		left join Cliente2 c on c.RucE=a.RucE and a.Cd_Clt=c.Cd_Clt
	where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
	group by 
			a.RucE,a.Ejer,b.Cd_Blc,a.NroCta,
			case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.Cd_Prv,''-'') else isnull(c.Cd_Clt,''-'') end,
			case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end,
			case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.NDoc,''-'') else isnull(c.NDoc,''-'') end,
			'' -TOTAL --> ''+case(isnull(len(a.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
        	 when 0 then isnull(nullif(p.ApPat +'' ''+p.ApMat+'', ''+p.Nom,''''),''------- SIN NOMBRE ------'')
        	 else p.RSocial  end  else case(isnull(len(c.RSocial),0)) 
       		 when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'', ''+c.Nom,''''),''------- SIN NOMBRE ------'')
        	 else c.RSocial end end
	having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		--and (isnull(a.Cd_Clt,'''')+isnull(p.Cd_Prv,'''')+isnull(a.Cd_TD,'''')+isnull(a.NroSre,'''')+isnull(a.NroDoc,''''))<>''''
	) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
Set @sql5_2=
	'
UNION ALL
	
Select 5 as Num,2 As Sub,r.Codigo,r.NroCta,p.NomCta,r.Cd_Aux,r.Cd_TDI,r.NDocAux,r.NomAux,r.Cd_TD,r.NroSre,r.NroDoc,r.Saldo
	,Total4,Total3,Total2,Total1
From (
	Select 
		a.RucE,a.Ejer,b.Cd_Blc As Codigo,a.NroCta as NroCta,
		case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.Cd_Prv,''-'') else isnull(c.Cd_Clt,''-'') end as Cd_Aux,
		case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end As Cd_TDI,
		case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.NDoc,''-'') else isnull(c.NDoc,''-'') end As NDocAux,
		case(isnull(len(a.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
        	 when 0 then isnull(nullif(p.ApPat +'' ''+p.ApMat+'', ''+p.Nom,''''),''------- SIN NOMBRE ------'')
        	 else p.RSocial  end  else case(isnull(len(c.RSocial),0)) 
       		 when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'', ''+c.Nom,''''),''------- SIN NOMBRE ------'')
        	 else c.RSocial end end as NomAux,
		isnull(a.Cd_TD,'''') as Cd_TD,
		isnull(a.NroSre,'''') as NroSre,
		isnull(a.NroDoc,'''') as NroDoc,
		Sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') as Saldo
		,0.00 as Total4,0.00 as Total3,0.00 as Total2,0.00 As Total1
	from Voucher a 
		Inner Join PlanCtas b On a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCta=b.NroCta and isnull(Cd_Blc,'''')<>'''' and isnull(b.Cd_Blc,'''') in ('+@Cd_Blc+')
		left join proveedor2 p on p.RucE=a.RucE and p.Cd_Prv=a.Cd_Prv
		left join Cliente2 c on c.RucE=a.RucE and a.Cd_Clt=c.Cd_Clt
	where a.RucE='''+@RucE+''' 
			and a.Ejer='''+@Ejer+''' 
			and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(a.IB_Anulado,0)<>1
	group by 
		    a.RucE,a.Ejer,b.Cd_Blc,a.NroCta,
			case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.Cd_Prv,''-'') else isnull(c.Cd_Clt,''-'') end,
			case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end,
			case(isnull(len(a.Cd_Clt),0)) when 0 then isnull(p.NDoc,''-'') else isnull(c.NDoc,''-'') end,
			case(isnull(len(a.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
        	 when 0 then isnull(nullif(p.ApPat +'' ''+p.ApMat+'', ''+p.Nom,''''),''------- SIN NOMBRE ------'')
        	 else p.RSocial  end  else case(isnull(len(c.RSocial),0)) 
       		 when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'', ''+c.Nom,''''),''------- SIN NOMBRE ------'')
        	 else c.RSocial end end,
		isnull(a.Cd_TD,''''),
		isnull(a.NroSre,''''),
		isnull(a.NroDoc,'''')
	having sum(a.MtoD'+@Mda+'-a.MtoH'+@Mda+') <> 0
		--and (isnull(a.Cd_Clt,'''')+isnull(p.Cd_Prv,'''')+isnull(a.Cd_TD,'''')+isnull(a.NroSre,'''')+isnull(a.NroDoc,''''))<>''''
	) As r
	Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
	'
End

PRINT '('
PRINT @sql0
PRINT @sql1
PRINT @sql2
PRINT @sql3
PRINT @sql4
PRINT @sql5_1
PRINT @sql5_2
PRINT ') Order by 3,4,1,8,6,2'

EXEC('('+@sql0+@sql1+@sql2+@sql3+@sql4+@sql5_1+@sql5_2+') Order by 3,4,1,8,6,2')
	 
-- Pruebas --
-- exec Rpt_BalanceGeneral_Anexo '11111111111','2011','00','09','''A100'',''A200'',''P100'',''P200''','01','1','1','1','1','1',null

-- Leyenda --
-- DI : 05/10/2011 <Creacion del procedimiento almacenado>
GO

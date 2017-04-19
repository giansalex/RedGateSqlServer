SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_CtasXCbr_CCteSaldoAmb7_Fec '11111111111','2010','','','','01/01/2010','31/12/2010',0,1,null
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteSaldoAmb7_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),--Se cambio de nombre, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@IB_VerSaldados bit,
@TipFiltro int,-- 0 NroCta, 1 NroDoc
@msj varchar(100) output
as



declare @Column varchar(200) declare @Groupby varchar(2000)
--CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE
--DETALLE

	if(@TipFiltro=0)
	Begin
		set @Column=' v.NroCta As NroCta, '
		set @Groupby='
			v.NroCta,
			isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')),
			Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
			Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
			Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
			End End,
			isnull(v.Cd_TD,''''),
			isnull(v.NroSre,''''),
			isnull(v.NroDoc,'''')
		'
	End
	else if(@TipFiltro=1)
	Begin
		set @Column=' '''' As NroCta, '
		set @Groupby='
			isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')),
			Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
			Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
			Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
			End End,
			isnull(v.Cd_TD,''''),
			isnull(v.NroSre,''''),
			isnull(v.NroDoc,'''')
		'
	End
	
declare @Consulta1 varchar(2000) declare @Consulta2 varchar(8000) declare @Consulta3 varchar(4000)
set @Consulta1='
	Select 
		isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')) As NDocAux,
		Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
		Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
		Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
		End End As NomAux,
	'
set @Consulta2='
		isnull(v.Cd_TD,'''') As Cd_TD,
		isnull(v.NroSre,'''') As NroSre,
		isnull(v.NroDoc,'''') As NroDoc,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '''' end) as FecED,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '''' end) as FecVD,
		Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,'''+Convert(varchar,@FechaFin)+''',IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,''Sin Especificar'')))) Else 0 End) As Saldo_Dias,
		Sum(v.MtoD) As Debe,
		Sum(v.MtoH) As Haber,
		Sum(v.MtoD) - Sum(v.MtoH) As Saldo,
		Sum(v.MtoD_ME) As Debe_ME,
		Sum(v.MtoH_ME) As Haber_ME,
		Sum(v.MtoD_ME) - Sum(v.MtoH_ME) As Saldo_ME
	From 
		Voucher v
		Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Left Join 
		(	Select 
				v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'''')) As CodAux,isnull(v.Cd_TD,'''') As Cd_TD,isnull(v.NroSre,'''') As NroSre,isnull(v.NroDoc,'''') As NroDoc,1 As IB_Saldado
			From 
				Voucher v 
				Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			Where  
				v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and isnull(v.IB_Anulado,0)<>1 and v.FecMov between '''+Convert(varchar,@FechaIni)+''' and '''+Convert(varchar,@FechaFin)+'''
			Group by 
				v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'''')), isnull(v.Cd_TD,''''), isnull(v.NroSre,''''), isnull(v.NroDoc,'''')
			Having 
				Sum(v.MtoD) - Sum(v.MtoH)=0 and Sum(v.MtoD_ME) - Sum(v.MtoH_ME)=0
		) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'''')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'''')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
		
	Where 
		v.RucE='''+Convert(varchar,@RucE)+'''
		and v.Ejer='''+Convert(varchar,@Ejer)+'''
		and isnull(v.IB_Anulado,0)<>1
		and v.FecMov between '''+Convert(varchar,@FechaIni)+''' and '''+Convert(varchar,@FechaFin)+'''
		and Case When isnull('''+Convert(varchar,Isnull(@NroCta1,''))+''','''')<>'''' Then v.NroCta Else '''' End>=isnull('''+Convert(varchar,Isnull(@NroCta1,''))+''','''')
		and Case When isnull('''+Convert(varchar,Isnull(@NroCta2,''))+''','''')<>'''' Then v.NroCta Else '''' End<=isnull('''+Convert(varchar,Isnull(@NroCta2,''))+''','''')
		and Case When isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')<>'''' Then v.Cd_Clt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')
	Group by 
	'
set @Consulta3='
	Having
		Sum(isnull(g.IB_Saldado + Convert(int,'''+Convert(varchar,@IB_VerSaldados)+'''),0))=0
		and (
		  Sum(v.MtoD) + Sum(v.MtoH) + Sum(v.MtoD_ME) + Sum(v.MtoH_ME) <>0
		)
	Order by NomAux,NroDoc
	'
	Print @Consulta1
	Print @Column
	Print @Consulta2
	Print @Groupby
	Print @Consulta3

Exec(@Consulta1+@Column+@Consulta2+@Groupby+@Consulta3)
--Pruebas:
--exec Rpt_CtasXCbr_CCteSaldoAmb5_Fec '11111111111','2010','','','','01/01/2010','31/12/2010',null
--exec Rpt_CtasXCbr_CCteSaldoAmb5 '11111111111','2010','','','','31/12/2010',null

--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
--Jesus -> Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--DEMO
--exec Rpt_CtasXCbr_CCteSaldoAmb5_Fec '11111111111','2010','CLT0000002','','','01/01/2008','30/09/2010',null
--MP: VIE 17-09-2010 --> Se quito las relaciones con la tabla Auxiliar y se relaciono con Cliente2
		     --> Se cambio el nombre del parametro @Cd_Aux a @Cd_Clt
--CM: PR03
--CM: RA01
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>

print @msj
GO

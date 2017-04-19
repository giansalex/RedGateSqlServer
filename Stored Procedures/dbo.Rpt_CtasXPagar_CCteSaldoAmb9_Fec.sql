SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldoAmb9_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@IB_VerSaldados bit,
@TipFiltro int,
@msj varchar(100) output
as

--CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

declare @Column varchar(200)
declare @Groupby varchar(2000)

	If(@TipFiltro=0)
	Begin
		set @Column='v.NroCta As NroCta, '
		set @Groupby='
			v.NroCta,
			isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')),
			Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
			Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
			Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
			End	End,
			isnull(v.Cd_TD,''''),
			isnull(v.NroSre,''''),
			isnull(v.NroDoc,'''')
		'
	End
	else if(@TipFiltro=0)
	Begin
		set @Column=''''' As NroCta, '
		set @Groupby='
			isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')),
			Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
			Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
			Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
			End	End,
			isnull(v.Cd_TD,''''),
			isnull(v.NroSre,''''),
			isnull(v.NroDoc,'''')
		'
	End
--DETALLE
Declare @Consulta1 Varchar(2000) Declare @Consulta2 Varchar(8000) Declare @Consulta3 Varchar(2000)

Set @Consulta1='
	Select 
		isnull(c.NDoc,isnull(r.NDoc,''-- Sin Auxiliar --'')) As NDocAux,
		Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
		Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
		Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
		End End As NomAux,
'
Set @Consulta2='
		v.NroCta,
		isnull(v.Cd_TD,'''') As Cd_TD,
		isnull(v.NroSre,'''') As NroSre,
		isnull(v.NroDoc,'''') As NroDoc,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '''' end) as FecED,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '''' end) as FecVD,
		Sum(case(v.IB_EsProv) when ''1'' then datediff(day,'''+Convert(varchar,@FechaFin)+''',v.FecCbr) else 0 end) as Saldo_Dias,  
		Sum(v.MtoD) As Debe,
		Sum(v.MtoH) As Haber,
		Sum(v.MtoD) - Sum(v.MtoH) As Saldo,
		Sum(v.MtoD_ME) As Debe_ME,
		Sum(v.MtoH_ME) As Haber_ME,
		Sum(v.MtoD_ME) - Sum(v.MtoH_ME) As Saldo_ME
	From 
		Voucher v
		Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Left Join 
		(	Select 
				v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'''')) As CodAux,isnull(v.Cd_TD,'''') As Cd_TD,isnull(v.NroSre,'''') As NroSre,isnull(v.NroDoc,'''') As NroDoc,1 As IB_Saldado
			From 
				Voucher v 
				Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
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
		and Case When isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''')<>'''' Then v.Cd_Prv Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''')
	Group by
'
set @Consulta3='
Having
	Sum(isnull(g.IB_Saldado + Convert(int,'''+Convert(varchar,@IB_VerSaldados)+'''),0))=0
	and (Sum(v.MtoD)+Sum(v.MtoH)<>0 and Sum(v.MtoD_ME)+Sum(v.MtoH_ME)<>0)
Order by 
	NomAux,NroDoc
'

Print @Consulta1
Print @Column
Print @Consulta2
Print @GroupBy
Print @Consulta3

exec(@Consulta1+@Column+@Consulta2+@GroupBy+@Consulta3)
--Pruebas:
--exec dbo.Rpt_CtasXPagar_CCteSaldoAmb7_Fec '11111111111','2010','','','','01/01/2010','01/12/2010',null
--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
--MP: DOM 19-09-2010 -->Modf: Se quito las relaciones con la tabla Auxiliar y se enlazo con Proveedor2
--CM: PR03
--CM: RA01
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>

--print @msj
GO

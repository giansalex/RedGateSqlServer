SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_CtasXPagar_CCteSaldo13_Fec '20527146136','2012','01/01/2012','31/07/2012','01',0,'PRV0188',null,null,null,0,null
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldo13_Fec]
@RucE nvarchar(11),
@Ejer varchar(4),
@FecIni datetime,
@FecFin datetime,
@Cd_Mda char(2),
@IB_VerSaldados bit,
@Cd_Prv char(7),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_TipProv nvarchar(3),
@TipFiltro int,
@msj varchar(100) output
as


--Cabecera
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FecIni,103)+ ' Al :' + Convert(varchar,@FecFin,103) as Fecha  from Empresa where Ruc=@RucE
declare @Consulta1 varchar(2000) declare @Consulta2 varchar(8000) declare @Consulta3 varchar(8000)
declare @Column varchar(100)
declare @Groupby varchar(4000)
declare @VarNum decimal(8,5)
set @VarNum = 0.00

declare @CondCta varchar (1000)
set @CondCta = ''
if(isnull(@NroCta1,'') <> '' or isnull(@NroCta2,'') <> '')
begin
	if(@NroCta1 = @NroCta2)
	begin
		set @CondCta =
						'
			and Case When '''+convert(varchar,isnull(@NroCta1,''))+'''='''' Then '''' Else v.NroCta End like ''' + Convert(nvarchar,isnull(@NroCta1,''))+'%'' '
	end 
	else
	begin
		set  @CondCta = '
			and Case When '''+convert(varchar,isnull(@NroCta1,''))+'''='''' Then '''' Else v.NroCta End >= isnull('''+convert(varchar,isnull(@NroCta1,''))+''','''')
			and Case When '''+convert(varchar,isnull(@NroCta2,''))+'''='''' Then '''' Else v.NroCta End <= isnull('''+convert(varchar,isnull(@NroCta2,''))+''','''')
						'	

	end
end 

if @IB_VerSaldados = 1
begin
	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
end
	if(@TipFiltro=0)
		Begin
			Set @Column='	v.NroCta As NroCta,'
			set @Groupby='
			Group by 
				v.NroCta,
				isnull(c.NDoc,isnull(r.NDoc,''-- Sin Documento --'')),
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
			Set @Column=' '''' As NroCta,'
			set @Groupby='
			Group by 
				isnull(c.NDoc,isnull(r.NDoc,''-- Sin Documento --'')),
				Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
				Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
				Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
				End End,
				isnull(v.Cd_TD,''''),
				isnull(v.NroSre,''''),
				isnull(v.NroDoc,'''')
			'
		End
	--print @Column

set @Consulta1 = '

Select 
	isnull(c.NDoc,isnull(r.NDoc,''-- Sin Documento --'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --''
	Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
	End End As NomAux,
	'
	--v.NroCta,
set @Consulta2 = '
	isnull(v.Cd_TD,'''') As Cd_TD,
	isnull(v.NroSre,'''') As NroSre,
	isnull(v.NroDoc,'''') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else Convert(nvarchar,isnull(v.FecEd,v.FecMov),103) End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,isnull(v.FecCbr,v.FecVD),103) Else Convert(nvarchar,v.FecVD,103) End) as FecVD,
	Max(Case When isnull(IB_EsProv,0)=1 Then DateDiff(day,'''+convert(varchar,@FecFin)+''',v.FecCbr) Else null End) As Saldo_Dias,
	
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	'''+convert(varchar,@Cd_Mda)+''' as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
	
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	
Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.FecMov between Convert(datetime,'''+convert(varchar,@FecIni,103)+'''+ '' 00:00:00'') and convert(datetime,'''+convert(varchar,@FecFin,103)+'''+ '' 23:59:29'')
	
	and isnull(v.Ib_Anulado,0)=0
	and Case When isnull('''+Convert(varchar,Isnull(@Cd_TipProv,''))+''','''')<>'''' Then c.Cd_TClt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_TipProv,''))+''','''')
	and Case When '''+convert(varchar,isnull(@Cd_Prv,''))+'''='''' Then '''' Else v.Cd_Prv End =isnull('''+convert(varchar,isnull(@Cd_Prv,''))+''','''')
'
	--isnull(c.NDoc,isnull(r.NDoc,'')),
	--Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
	--															Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	--																								   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	--																 End 							  
	--End,
	--v.NroCta,
	--isnull(v.Cd_TD,''),
	--isnull(v.NroSre,''),
	--isnull(v.NroDoc,'')

set @Consulta3 = '

Having
	Sum(Case When '''+@Cd_Mda+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+@Cd_Mda+'''=''01'' Then v.MtoH Else v.MtoH_ME End) 
	+ '+CONVERT(varchar,@VarNum) +' <> 0
Order by NomAux
'
print @Consulta1
print @Column
print @Consulta2
print @CondCta
print @Groupby
print @Consulta3
exec(@Consulta1+@Column+@Consulta2+@CondCta+@Groupby+@Consulta3)	
-- Leyenda --
-- JJ <Creado>
--DI : 24/05/2011 <reestructurado>
--JA: 08/09/2011 <Rearmado>
GO

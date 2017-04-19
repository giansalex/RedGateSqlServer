SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Rpt_CtasXCbr_CCteResum7 '11111111111','2011','','','','01/07/2010','31/07/2010','','','01',0,'',null

CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResum7]
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
@Cd_TipClt nvarchar(3),
@msj varchar(100) output
as
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha  from Empresa where Ruc=@RucE


declare @TipFiltro int
set @TipFiltro = 0

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

--Detalle

set @Consulta1 = '
select 	
	NDocAux,
	NomAux as NomAux,
	Sum(Debe) As Debe,
	Sum(Haber) As Haber,
	Sum(Saldo) As Saldo,
	Max(Cd_MdRg) As Moneda 
from 
(
Select 
	isnull(c.NDoc,isnull(r.NDoc,''-- Sin Documento --'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' 
	Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) 
	End End As NomAux,
	'

set @Consulta2 = '
	isnull(v.Cd_TD,'''') As Cd_TD,
	isnull(v.NroSre,'''') As NroSre,
	isnull(v.NroDoc,'''') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	Max(Case When isnull(IB_EsProv,0)=1 Then DateDiff(day,'''+convert(varchar,@FechaFin)+''',v.FecCbr) Else null End) As Saldo_Dias,
	
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	'''+convert(varchar,@Cd_Mda)+''' as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.FecMov between '''+convert(varchar,@FechaIni)+''' and '''+convert(varchar,@FechaFin)+'''

	and isnull(v.Ib_Anulado,0)=0
	and Case When isnull('''+Convert(varchar,Isnull(@Cd_TipClt,''))+''','''')<>'''' Then c.Cd_TClt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_TipClt,''))+''','''')
	and Case When '''+convert(varchar,isnull(@Cd_Clt,''))+'''='''' Then '''' Else v.Cd_Clt End =isnull('''+convert(varchar,isnull(@Cd_Clt,''))+''','''')
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

) as t
group by NDocAux, NomAux
order by NomAux

'

print @Consulta1
print @Column
print @Consulta2
print @CondCta
print @Groupby
print @Consulta3
exec(@Consulta1+@Column+@Consulta2+@CondCta+@Groupby+@Consulta3)	
	
	
	


/*
Creado JAvier <12/07/2011> ... el mismo Query pero con el TipoCliente
--Rpt_CtasXCbr_CCteResum7 '11111111111','2010','','','','01/12/2010','31/12/2010',null,'','01',1,'',null
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>
--JJ 09/08/2011 <Se verifico el sp, cambio todo la condicion del from al order by>
*/
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Ltr_Letra_CobroCons_Hist2 '20513272848','01/08/2012','30/08/2012','01','''CLT0000063'',''CLT0000067''','','','',null
CREATE PROC [dbo].[Ltr_Letra_CobroCons_Hist2]

@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@Cd_Mda char(2),
@Cd_Clt varchar(8000),
@Cd_TD nvarchar(2),
@NroSre varchar(5),
@NroDoc nvarchar(15),
@msj varchar(100) output

AS

declare @var nvarchar(2)
set @var = '='
if(isnull(@Cd_Clt,'')<>'')
begin
set @var = 'in'
end


Declare @Cd_Cnj varchar(10)
Set @Cd_Cnj=''
if(isnull(@Cd_TD,'')<>'' or isnull(@NroDoc,'')<>'')
Begin
	Begin
		Select top 1 @Cd_Cnj=Cd_Cnj 
		From CanjeDetRM 
		Where RucE=@RucE
			and FecMov between @FecIni and @FecFin
			and Case When isnull(@Cd_Clt,'')<>'' Then Cd_Clt Else '' End = isnull(@Cd_Clt,'')
			and Case When isnull(@Cd_TD,'')<>'' Then Cd_TD Else '' End = isnull(@Cd_TD,'')
			and Case When isnull(@NroSre,'')<>'' Then NroSre Else '' End = isnull(@NroSre,'')
			and Case When isnull(@NroDoc,'')<>'' Then NroDoc Else '' End like '%'+isnull(@NroDoc,'')
	End
	if(isnull(@Cd_Cnj,'')='')
	Begin
		Select top 1 @Cd_Cnj=l.Cd_Cnj 
		From Letra_CobroRM l
			Left Join CanjeDetRM d On d.RucE=l.RucE and d.Cd_Cnj=l.Cd_Cnj
		Where l.RucE=@RucE
			and d.FecMov between @FecIni and @FecFin
			and Case When isnull(@Cd_Clt,'')<>'' Then d.Cd_Clt Else '' End = isnull(@Cd_Clt,'')
			and Case When isnull(@Cd_TD,'')<>'' Then l.Cd_TD Else '' End = isnull(@Cd_TD,'')
			and Case When isnull(@NroDoc,'')<>'' Then isnull(l.NroRenv,'')+isnull(l.NroLtr,'') Else '' End like '%'+isnull(@NroDoc,'')
	End
End
Print 'Codigo Canje : '+@Cd_Cnj

-- CLIENTE --
--**********************************************************
declare @SqlCliente varchar(8000)
set @SqlCliente = '
Select 
	c.Cd_Clt,
	t.NDoc AS NDocClt,
	Case When isnull(t.RSocial,'''')<>'''' then t.RSocial Else isnull(t.Nom,'''')+'' ''+isnull(t.ApPat,'''')+'' ''+isnull(t.ApMat,'''') End NomClt
From 
	CanjeDetRM c
	Left Join Cliente2 t On t.RucE=c.RucE and t.Cd_Clt=c.Cd_Clt
Where 
	c.RucE='''+@RucE+'''
	
	and Case When '+case when isnull(@Cd_Clt,'')<>''then '''X''' else '''''' end+' <>'''' Then c.Cd_Clt Else '''' End '+@var+'('+case when isnull(@Cd_Clt,'')<>''then @Cd_Clt else '''''' end+')
Group by 
	c.Cd_Clt,t.NDoc,Case When isnull(t.RSocial,'''')<>'''' then t.RSocial Else isnull(t.Nom,'''')+'' ''+isnull(t.ApPat,'''')+'' ''+isnull(t.ApMat,'''') End
'
print (@SqlCliente)

-- DOCUMENTOS --
--**********************************************************
declare @SqlDocumento varchar(8000)
set @SqlDocumento = '
Select 
	c.Cd_Clt,c.Cd_Cnj,
	case when isnull(c.Cd_Ltr,'''')='''' then c.Cd_TD else l.Cd_TD end Cd_TD, 
	t.NCorto,
	c.NroSre,
	case when isnull(c.Cd_Ltr,'''')='''' then c.NroDoc else l.NroLtr end as NroDoc,
	Case ('''+@Cd_Mda+''') When ''01'' Then Case When c.Cd_Mda=''01'' Then c.TotalDoc Else Convert(decimal(13,2),c.TotalDoc*c.TipCam) End
				   When ''02'' Then Case When c.Cd_Mda=''01'' Then Convert(decimal(13,2),c.TotalDoc/c.TipCam) Else c.TotalDoc End
				   Else 0.00
	End TotalDoc
From
	CanjeDetRM c
	left join 
	(
		select lc.Cd_Ltr,lc.RucE,lc.Cd_TD,lc.NroLtr from Letra_CobroRM lc where RucE = '''+@RucE+'''
		group by lc.Cd_Ltr,lc.RucE,lc.Cd_TD,lc.NroLtr
	) as l on c.RucE =l.RucE and c.Cd_Ltr = l.Cd_Ltr
	Left Join TipDoc t On t.Cd_TD=isnull(c.Cd_TD,l.Cd_TD)
Where
	c.RucE='''+@RucE+'''
	and c.FecMov between '''+convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''

	and Case When '+case when isnull(@Cd_Clt,'')<>''then '''X''' else '''''' end+' <>'''' Then c.Cd_Clt Else '''' End '+@var+'('+case when isnull(@Cd_Clt,'')<>''then @Cd_Clt else '''''' end+')
	and Case When isnull('''+@Cd_Cnj+''','''')<>'''' then c.Cd_Cnj Else '''' End = isnull('''+@Cd_Cnj+''','''')	
'
print (@SqlDocumento)

-- LETRAS --
--**********************************************************
declare @SqlLetras varchar(8000)
set @SqlLetras = ' 
Select 
	d.Cd_Clt,c.Cd_Cnj,c.Cd_TD,t.NCorto,'''' AS NroSre,isnull(c.NroRenv,'''')+isnull(c.NroLtr,'''') As NroDoc,
	Case ('''+@Cd_Mda+''') When ''01'' Then Case When d.Cd_Mda=''01'' Then c.Total Else Convert(decimal(13,2),c.Total*d.TipCam) End
				   When ''02'' Then Case When d.Cd_Mda=''01'' Then Convert(decimal(13,2),c.Total/d.TipCam) Else c.Total End
				   Else 0.00
	End Total,
	Convert(varchar,c.FecGiro,103) As FecGiro,c.Plazo,Convert(varchar,c.FecVenc,103) AS FecVenc,
	Case When isnull(d.IB_Anulado,0)=1 Then ''ANULADO'' Else '''' End As Estado
From
	Letra_CobroRM c
	Inner Join CanjeDetRM d On d.RucE=c.RucE and d.Cd_Cnj=c.Cd_Cnj 
	Left Join TipDoc t On t.Cd_TD=c.Cd_TD
Where
	c.RucE='''+@RucE+'''
	and d.FecMov between '''+convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
	
	and Case When '+case when isnull(@Cd_Clt,'')<>''then '''X''' else '''''' end+' <>'''' Then d.Cd_Clt Else '''' End '+@var+'('+case when isnull(@Cd_Clt,'')<>''then @Cd_Clt else '''''' end+')
	and Case When isnull('''+@Cd_Cnj+''','''')<>'''' then c.Cd_Cnj Else '''' End = isnull('''+@Cd_Cnj+''','''')	
Group by 
	d.Cd_Clt,c.Cd_Cnj,c.Cd_TD,t.NCorto,isnull(c.NroRenv,'''')+isnull(c.NroLtr,''''),c.Total,
	Convert(varchar,c.FecGiro,103),c.Plazo,Convert(varchar,c.FecVenc,103),
	Case When isnull(d.IB_Anulado,0)=1 Then ''ANULADO'' Else '''' End
	,d.Cd_Mda,d.TipCam
'
print (@SqlLetras)

---------------------
exec (@SqlCliente)
exec (@SqlDocumento)
exec (@SqlLetras)


-- DATOS GENERALES --
--**********************************************************

Select Ruc,RSocial,Direccion,Telef,@Cd_Mda As Cd_Mda
,Convert(nvarchar,@FecIni,103) as FecDesde
,Convert(nvarchar,@FecFin,103) as FecHasta 
From Empresa Where Ruc=@RucE



-- Leyenda --
-- DI : 24/02/2012 <Creacion del SP>
-- DI : 27/02/2012 <Se agrego una consulta de datos generales de la empresa y se agrego configuracion de moneda>

GO

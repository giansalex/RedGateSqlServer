SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_Letra_PagoCons_Hist]

@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@Cd_Mda char(2),
@Cd_Prv char(7),
@Cd_TD nvarchar(2),
@NroSre varchar(5),
@NroDoc nvarchar(15),
@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)
Declare @FecIni datetime
Declare @FecFin datetime
Declare @Cd_Mda char(2)
Declare @Cd_Clt char(10)
Declare @Cd_TD nvarchar(2)
Declare @NroSre varchar(5)
Declare @NroDoc nvarchar(15)

Set @RucE='10425049891'
Set @FecIni='01/02/2012'
Set @FecFin='30/03/2012'
Set @Cd_Mda='02'
Set @Cd_Clt='CLT0000003'
Set @Cd_TD=''
Set @NroSre=''
Set @NroDoc=''
*/

Declare @Cd_Cnj varchar(10)
Set @Cd_Cnj=''
if(isnull(@Cd_TD,'')<>'' or isnull(@NroDoc,'')<>'')
Begin
	Begin
		Select top 1 @Cd_Cnj=Cd_Cnj 
		From CanjePagoDetRM 
		Where RucE=@RucE
			and FecMov between @FecIni and @FecFin
			and Case When isnull(@Cd_Prv,'')<>'' Then Cd_Prv Else '' End = isnull(@Cd_Prv,'')
			and Case When isnull(@Cd_TD,'')<>'' Then Cd_TD Else '' End = isnull(@Cd_TD,'')
			and Case When isnull(@NroSre,'')<>'' Then NroSre Else '' End = isnull(@NroSre,'')
			and Case When isnull(@NroDoc,'')<>'' Then NroDoc Else '' End like '%'+isnull(@NroDoc,'')
	End
	if(isnull(@Cd_Cnj,'')='')
	Begin
		Select top 1 @Cd_Cnj=l.Cd_Cnj 
		From Letra_PagoRM l
			Left Join CanjePagoDetRM d On d.RucE=l.RucE and d.Cd_Cnj=l.Cd_Cnj
		Where l.RucE=@RucE
			and d.FecMov between @FecIni and @FecFin
			and Case When isnull(@Cd_Prv,'')<>'' Then d.Cd_Prv Else '' End = isnull(@Cd_Prv,'')
			and Case When isnull(@Cd_TD,'')<>'' Then l.Cd_TD Else '' End = isnull(@Cd_TD,'')
			and Case When isnull(@NroDoc,'')<>'' Then isnull(l.NroRenv,'')+isnull(l.NroLtr,'') Else '' End like '%'+isnull(@NroDoc,'')
	End
End
Print 'Codigo Canje : '+@Cd_Cnj

-- CLIENTE --
--**********************************************************
Select 
	c.Cd_Prv,
	t.NDoc AS NDocClt,
	Case When isnull(t.RSocial,'')<>'' then t.RSocial Else isnull(t.Nom,'')+' '+isnull(t.ApPat,'')+' '+isnull(t.ApMat,'') End NomClt
From 
	CanjePagoDetRM c
	Left Join Proveedor2 t On t.RucE=c.RucE and t.Cd_Prv=c.Cd_Prv
Where 
	c.RucE=@RucE
	and Case When isnull(@Cd_Prv,'')<>'' Then c.Cd_Prv Else '' End = isnull(@Cd_Prv,'') 
Group by 
	c.Cd_Prv,t.NDoc,Case When isnull(t.RSocial,'')<>'' then t.RSocial Else isnull(t.Nom,'')+' '+isnull(t.ApPat,'')+' '+isnull(t.ApMat,'') End

-- DOCUMENTOS --
--**********************************************************
Select 
	c.Cd_Prv,c.Cd_Cnj,
	case when isnull(c.Cd_Ltr,'')='' then c.Cd_TD else l.Cd_TD end Cd_TD, 
	t.NCorto,
	c.NroSre,
	case when isnull(c.Cd_Ltr,'')='' then c.NroDoc else l.NroLtr end as NroDoc,
	Case (@Cd_Mda) When '01' Then Case When c.Cd_Mda='01' Then c.TotalDoc Else Convert(decimal(13,2),c.TotalDoc*c.TipCam) End
				   When '02' Then Case When c.Cd_Mda='01' Then Convert(decimal(13,2),c.TotalDoc/c.TipCam) Else c.TotalDoc End
				   Else 0.00
	End TotalDoc
From
	CanjePagoDetRM c
	left join 
	(
		select lc.Cd_Ltr,lc.RucE,lc.Cd_TD,lc.NroLtr from Letra_PagoRM lc where RucE = @RucE
		group by lc.Cd_Ltr,lc.RucE,lc.Cd_TD,lc.NroLtr
	) as l on c.RucE =l.RucE and c.Cd_Ltr = l.Cd_Ltr
	Left Join TipDoc t On t.Cd_TD=isnull(c.Cd_TD,l.Cd_TD)
Where
	c.RucE=@RucE
	and c.FecMov between @FecIni and @FecFin
	and Case When isnull(@Cd_Prv,'')<>'' Then c.Cd_Prv Else '' End = isnull(@Cd_Prv,'') 
	and Case When isnull(@Cd_Cnj,'')<>'' then c.Cd_Cnj Else '' End = isnull(@Cd_Cnj,'')	
	
-- LETRAS --
--**********************************************************
Select 
	d.Cd_Prv,c.Cd_Cnj,c.Cd_TD,t.NCorto,'' AS NroSre,isnull(c.NroRenv,'')+isnull(c.NroLtr,'') As NroDoc,
	Case (@Cd_Mda) When '01' Then Case When d.Cd_Mda='01' Then c.Total Else Convert(decimal(13,2),c.Total*d.TipCam) End
				   When '02' Then Case When d.Cd_Mda='01' Then Convert(decimal(13,2),c.Total/d.TipCam) Else c.Total End
				   Else 0.00
	End Total,
	Convert(varchar,c.FecGiro,103) As FecGiro,c.Plazo,Convert(varchar,c.FecVenc,103) AS FecVenc,
	Case When isnull(d.IB_Anulado,0)=1 Then 'ANULADO' Else '' End As Estado
From
	Letra_PagoRM c
	Inner Join CanjePagoDetRM d On d.RucE=c.RucE and d.Cd_Cnj=c.Cd_Cnj 
	Left Join TipDoc t On t.Cd_TD=c.Cd_TD
Where
	c.RucE=@RucE
	and d.FecMov between @FecIni and @FecFin
	and Case When isnull(@Cd_Prv,'')<>'' Then d.Cd_Prv Else '' End = isnull(@Cd_Prv,'') 
	and Case When isnull(@Cd_Cnj,'')<>'' then c.Cd_Cnj Else '' End = isnull(@Cd_Cnj,'')	
Group by 
	d.Cd_Prv,c.Cd_Cnj,c.Cd_TD,t.NCorto,isnull(c.NroRenv,'')+isnull(c.NroLtr,''),c.Total,
	Convert(varchar,c.FecGiro,103),c.Plazo,Convert(varchar,c.FecVenc,103),
	Case When isnull(d.IB_Anulado,0)=1 Then 'ANULADO' Else '' End
	,d.Cd_Mda,d.TipCam
	
-- DATOS GENERALES --
--**********************************************************
Select Ruc,RSocial,Direccion,Telef,@Cd_Mda As Cd_Mda From Empresa Where Ruc=@RucE



-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
GO

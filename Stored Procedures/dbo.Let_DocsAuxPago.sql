SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAuxPago]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(10),

@Cd_TD nvarchar(4),

@VerLtr bit,

@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)  Set @RucE='11111111111'
Declare @Ejer nvarchar(4)	Set @Ejer='2011'
Declare @Cd_Prv char(10)	Set @Cd_Prv='PRV0253'
Declare @Cd_TD nvarchar(4)	Set @Cd_TD=''
*/

if(@VerLtr = 1)
Begin
	select 
		convert(varchar,doc.Cd_TD) As DR_CdTD,'' As DR_NSre,doc.NroDoc As DR_NDoc,
		doc.Cd_Com,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select d.* From Com_Letras_Pago d Where d.RucE=@RucE and /*d.Ejer=@Ejer and*/ d.Cd_Prv=@Cd_Prv
		Union
		Select c.* from Com_PagosLtr c where c.RucE=@RucE and /*c.Ejer=@Ejer and*/ c.Cd_Prv=@Cd_Prv and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in (Select c.Cd_Ltr From CanjePagoDet c Inner Join CanjePago e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0)
		and doc.Cd_Ltr not in (Select l.Cd_Ltr From CanjePago c Inner Join Letra_Pago l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and c.Cd_Prv=@Cd_Prv and isnull(c.IB_Anulado,0)=1)
	Group by doc.Cd_Com,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	
	select 
		convert(varchar,doc.Cd_TD) As DR_CdTD,'' As DR_NSre,doc.NroDoc As DR_NDoc,
		doc.Cd_Com,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select d.* From Com_Letras_Pago d Where d.RucE=@RucE and /*d.Ejer=@Ejer and*/ d.Cd_Prv=@Cd_Prv
		Union
		Select c.* from Com_PagosLtr c where c.RucE=@RucE and /*c.Ejer=@Ejer and*/ c.Cd_Prv=@Cd_Prv and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in (Select c.Cd_Ltr From CanjePagoDet c Inner Join CanjePago e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0)
		and doc.Cd_Ltr not in (Select l.Cd_Ltr From CanjePago c Inner Join Letra_Pago l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and c.Cd_Prv=@Cd_Prv and isnull(c.IB_Anulado,0)=1)
	Group by doc.Cd_Com,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0


End
Else
Begin
	select 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,
		'' As Cd_Com,'' As Cd_Ltr,
		doc.DR_CdTD As Cd_TD,t.NCorto As NomTD, doc.DR_NSre As NroSre, doc.DR_NDoc As NroDoc, '' As Cd_Mda,
		'' As NomMda,
		0.000 As CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,1) As Sel
	from
	(	Select Res.* 
		,Case When isnull(c.DR_CdTD,'')<>'' Then c.DR_CdTD Else Res.Cd_TD End As DR_CdTD
		,Case When isnull(c.DR_NSre,'')<>'' Then c.DR_NSre Else Res.NroSre End As DR_NSre
		,Case When isnull(c.DR_NDoc,'')<>'' Then c.DR_NDoc Else Res.NroDoc End As DR_NDoc
		from
		(
		Select d.* From Com_Documentos d Where d.RucE=@RucE and d.Cd_Prv=@Cd_Prv and d.Cd_TD<>'39'
		Union
		Select p.* from Com_Pagos p where p.RucE=@RucE and p.Cd_Prv=@Cd_Prv and p.Cd_TD<>'39'
		) As Res
		Left Join Compra c On c.RucE=Res.RucE and c.Ejer=Res.Ejer and c.Cd_Com=Res.Cd_Com
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.DR_CdTD
	Where
		doc.Cd_Com not in (Select c.Cd_Com From CanjePagoDet c Inner Join CanjePago e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	Where c.RucE=@RucE and isnull(c.Cd_Com,'')<>'')
	Group by 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,t.NCorto--,doc.Cd_Vta
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	
	
	select 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,
		doc.Cd_Com,doc.Cd_Ltr,doc.Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select Res.* 
		,Case When isnull(c.DR_CdTD,'')<>'' Then c.DR_CdTD Else Res.Cd_TD End As DR_CdTD
		,Case When isnull(c.DR_NSre,'')<>'' Then c.DR_NSre Else Res.NroSre End As DR_NSre
		,Case When isnull(c.DR_NDoc,'')<>'' Then c.DR_NDoc Else Res.NroDoc End As DR_NDoc
		from
		(
		Select d.* From Com_Documentos d Where d.RucE=@RucE and d.Cd_Prv=@Cd_Prv and d.Cd_TD<>'39'
		Union
		Select p.* from Com_Pagos p where p.RucE=@RucE and p.Cd_Prv=@Cd_Prv and p.Cd_TD<>'39'
		) As Res
		Left Join Compra c On c.RucE=Res.RucE and c.Ejer=Res.Ejer and c.Cd_Com=Res.Cd_Com
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Com not in (Select c.Cd_Com From CanjePagoDet c Inner Join CanjePago e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	Where c.RucE=@RucE and isnull(c.Cd_Com,'')<>'')
	Group by 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,	
		doc.Cd_Com,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
End

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
GO

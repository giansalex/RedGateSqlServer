SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAux2]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),

@Cd_TD nvarchar(4),

@VerLtr bit,

@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)  Set @RucE='11111111111'
Declare @Ejer nvarchar(4)	Set @Ejer='2011'
Declare @Cd_Clt char(10)	Set @Cd_Clt='CLT0003645'
Declare @Cd_TD nvarchar(4)	Set @Cd_TD=''
*/

if(@VerLtr = 1)
Begin
	select 
		convert(varchar,doc.Cd_TD) As DR_CdTD,'' As DR_NSre,doc.NroDoc As DR_NDoc,
		doc.Cd_Vta,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select d.* From Vta_Letras_Cobro d Where d.RucE=@RucE and /*d.Ejer=@Ejer and*/ d.Cd_Clt=@Cd_Clt
		Union
		Select c.* from Vta_CobrosLtr c where c.RucE=@RucE and /*c.Ejer=@Ejer and*/ c.Cd_Clt=@Cd_Clt and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in (Select c.Cd_Ltr From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0)
		and doc.Cd_Ltr not in (Select l.Cd_Ltr From Canje c Inner Join Letra_Cobro l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(c.IB_Anulado,0)=1)
	Group by doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	
	select 
		convert(varchar,doc.Cd_TD) As DR_CdTD,'' As DR_NSre,doc.NroDoc As DR_NDoc,
		doc.Cd_Vta,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select d.* From Vta_Letras_Cobro d Where d.RucE=@RucE and /*d.Ejer=@Ejer and*/ d.Cd_Clt=@Cd_Clt
		Union
		Select c.* from Vta_CobrosLtr c where c.RucE=@RucE and /*c.Ejer=@Ejer and*/ c.Cd_Clt=@Cd_Clt and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in (Select c.Cd_Ltr From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0)
		and doc.Cd_Ltr not in (Select l.Cd_Ltr From Canje c Inner Join Letra_Cobro l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(c.IB_Anulado,0)=1)
	Group by doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0

End
Else
Begin
	/*
	select 
		doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select d.* From Vta_Documentos d Where d.RucE=@RucE and /*d.Ejer=@Ejer and*/ d.Cd_Clt=@Cd_Clt
		and case when ISNULL(@Cd_TD,'')='' Then '' Else d.Cd_TD End = ISNULL(@Cd_TD,'') 
		Union
		Select c.* from Vta_Cobros c where c.RucE=@RucE and /*c.Ejer=@Ejer and*/ c.Cd_Clt=@Cd_Clt
		and case when ISNULL(@Cd_TD,'')='' Then '' Else c.Cd_TD End = ISNULL(@Cd_TD,'')
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Vta not in (Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Vta,'')<>'')
	Group by doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	*/
	select 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,
		'' As Cd_Vta,'' As Cd_Ltr,
		doc.DR_CdTD As Cd_TD,t.NCorto As NomTD, doc.DR_NSre As NroSre, doc.DR_NDoc As NroDoc, '' As Cd_Mda,
		'' As NomMda,
		0.000 As CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,1) As Sel
	from
	(	Select Res.* 
		,Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else Res.Cd_TD End As DR_CdTD
		,Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else Res.NroSre End As DR_NSre
		,Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else Res.NroDoc End As DR_NDoc
		from
		(
		Select d.* From Vta_Documentos d Where d.RucE=@RucE and d.Cd_Clt=@Cd_Clt and d.Cd_TD<>'39'
		Union
		Select c.* from Vta_Cobros c where c.RucE=@RucE and c.Cd_Clt=@Cd_Clt and c.Cd_TD<>'39'
		) As Res
		Left Join Venta v On v.RucE=Res.RucE and v.Eje=Res.Ejer and v.Cd_Vta=Res.Cd_Vta
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.DR_CdTD
	--Where
	--	doc.Cd_Vta not in (Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	--Where c.RucE=@RucE and isnull(c.Cd_Vta,'')<>'')
	Group by 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,t.NCorto--,doc.Cd_Vta
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	
	
	select 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,
		doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		Sum(doc.CamMda) As CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Convert(bit,0) As Sel
	from
	(	Select Res.* 
		,Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else Res.Cd_TD End As DR_CdTD
		,Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else Res.NroSre End As DR_NSre
		,Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else Res.NroDoc End As DR_NDoc
		from
		(
		Select d.* From Vta_Documentos d Where d.RucE=@RucE and d.Cd_Clt=@Cd_Clt and d.Cd_TD<>'39'
		Union
		Select c.* from Vta_Cobros c where c.RucE=@RucE and c.Cd_Clt=@Cd_Clt and c.Cd_TD<>'39'
		) As Res
		Left Join Venta v On v.RucE=Res.RucE and v.Eje=Res.Ejer and v.Cd_Vta=Res.Cd_Vta
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	--Where
		--doc.Cd_Vta not in (Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	--Where c.RucE=@RucE and isnull(c.Cd_Vta,'')<>'')
	Group by 
		doc.DR_CdTD,doc.DR_NSre,doc.DR_NDoc,	
		doc.Cd_Vta,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda--,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
End

-- Leyenda --
-- DI : 09/12/2011 <Creacion del SP>
GO

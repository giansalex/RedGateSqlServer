SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAux4]

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
		doc.Cd_Vta,'' As Cd_Vou,Max(doc.Cd_Ltr) As Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
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
	Group by doc.Cd_Vta/*,doc.Cd_Ltr*/,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
	
	select 
		convert(varchar,doc.Cd_TD) As DR_CdTD,'' As DR_NSre,doc.NroDoc As DR_NDoc,
		doc.Cd_Vta, '' As Cd_Vta,'' As Cd_Vou,Max(doc.Cd_Ltr) As Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
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
	Group by doc.Cd_Vta/*,doc.Cd_Ltr*/,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0

End
Else
Begin

	SELECT
		TB.DR_CdTD,TB.DR_NSre,TB.DR_NDoc,
		'' As Cd_Vta,
		'' As Cd_Vou,
		'' As Cd_Ltr,
		TB.DR_CdTD As Cd_TD,
		t.NCorto As NomTD,
		TB.DR_NSre As NroSre,
		TB.DR_NDoc As NroDoc,
		'' As Cd_Mda,'' As NomMda,'' As CamMda,
		Sum(TB.SaldoS) As SaldoS,
		Sum(TB.SaldoD) As SaldoD
	FROM
		(	
			Select * From Doc_Venta Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VentaCbr Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VentaLtr Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VouVta Where RucE=@RucE and Cd_Clt=@Cd_Clt
		) TB
		LEFT JOIN TipDoc t On t.Cd_TD=TB.DR_CdTD
	GROUP BY 
		TB.DR_CdTD,TB.DR_NSre,TB.DR_NDoc,t.NCorto
	HAVING 
		Sum(TB.SaldoS)+Sum(TB.SaldoD)<>0
	ORDER BY 
		TB.DR_CdTD,TB.DR_NSre,TB.DR_NDoc
		



	SELECT
		TB.DR_CdTD,TB.DR_NSre,TB.DR_NDoc,
		TB.Cd_Vta,
		CASE WHEN isnull(TB.Cd_Vou,0)<=0 THEN '' ELSE Convert(varchar,TB.Cd_Vou) END As Cd_Vou,
		TB.Cd_Ltr,
		TB.Cd_TD,TB.NomTD,TB.NroSre,TB.NroDoc,TB.Cd_Mda,TB.NomMda,TB.CamMda,
		Sum(TB.SaldoS) As SaldoS,
		Sum(TB.SaldoD) As SaldoD
	FROM
		(	
			Select * From Doc_Venta Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VentaCbr Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VentaLtr Where RucE=@RucE and Cd_Clt=@Cd_Clt
			UNION ALL
			Select * From Doc_VouVta Where RucE=@RucE and Cd_Clt=@Cd_Clt
		) TB
	GROUP BY 
		TB.DR_CdTD,TB.DR_NSre,TB.DR_NDoc,TB.Cd_Vta,TB.Cd_Vou,TB.Cd_Ltr,TB.Cd_TD,TB.NomTD,TB.NroSre,TB.NroDoc,TB.Cd_Mda,TB.NomMda,TB.CamMda
	HAVING 
		Sum(TB.SaldoS)+Sum(TB.SaldoD)<>0
	ORDER BY 
		TB.Cd_TD,TB.NroSre,TB.NroDoc
	
End

-- Leyenda --
-- DI : 16/08/2012 <Creacion del SP>

GO

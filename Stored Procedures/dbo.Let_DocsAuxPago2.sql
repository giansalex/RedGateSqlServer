SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAuxPago2]

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
		doc.Cd_Com,'' As Cd_Vou,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
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
		doc.Cd_Com,'' As Cd_Vou,doc.Cd_Ltr,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto As NomTD, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
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
	-- GRUPO --
	--***********************************************************************
	SELECT
		Tb.DR_CdTD,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Com,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.DR_CdTD As Cd_TD,t.NCorto As NomTD,Tb.DR_NSre As NroSre,Tb.DR_NDoc As NroDoc,
		Tb.Cd_Mda,
		'' As NomMda,
		Tb.CamMda,
		Sum(Tb.TotalS) As SaldoS,Sum(Tb.TotalD) As SaldoD
		,Convert(bit,0) As Sel
    FROM 
    (
		SELECT 
			Case When isnull(DR_CdTD,'')<>'' Then DR_CdTD Else Cd_TD End As DR_CdTD,
			Case When isnull(DR_NSre,'')<>'' Then DR_NSre Else NroSre End As DR_NSre,
			Case When isnull(DR_NDoc,'')<>'' Then DR_NDoc Else NroDoc End As DR_NDoc,
			'' As Cd_Com,'' AS Cd_Vou,'' AS Cd_Ltr,Cd_TD,NroSre,NroDoc,'' As Cd_Mda,'' As CamMda,
			CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), Total * CamMda) ELSE Total END AS TotalS, 
			CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
		FROM 
			Compra 
		WHERE 
			RucE=@RucE and ISNULL(IB_Anulado, 0) = 0 and ISNULL(Cd_Prv,'')=@Cd_Prv
			
		UNION
		
		SELECT 
			Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
			Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
			Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
			'' As Cd_Com,'' AS Cd_Vou,'' AS Cd_Ltr,v.Cd_TD,v.NroSre,v.NroDoc,'' As Cd_Mda,'' As CamMda,
			v.MtoH-v.MtoD As TotalS,v.MtoH_ME-v.MtoD_ME As TotalS
		FROM
			Voucher v
			Inner Join (
						SELECT RucE,Cd_Com,RegCtb,Cd_Prv,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda
						FROM Compra WHERE RucE=@RucE and ISNULL(IB_Anulado, 0)=0 and ISNULL(Cd_Prv,'')=@Cd_Prv	
						) r On r.RucE=v.RucE and r.Cd_Prv=v.Cd_Prv and r.Cd_TD=v.Cd_TD and r.NroSre=v.NroSre and r.NroDoc=v.NroDoc

	) AS Tb
	Inner Join TipDoc t On t.Cd_TD=Tb.DR_CdTD
	Group by Tb.DR_CdTD,t.NCorto,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Com,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_Mda,Tb.CamMda
	Having	Sum(Tb.TotalS)+Sum(Tb.TotalD)<>0
	
	UNION ALL
	
	SELECT
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
		'' As Cd_Com,'' As Cd_Vou,'' As Cd_Ltr,
		v.Cd_TD,t.NCorto As NomTD,v.NroSre,v.NroDoc,'' As Cd_Mda,'' As NomMda,'' As CamMda,
		Sum(v.MtoH)-Sum(v.MtoD) As SaldoS, 
        Sum(v.MtoH_ME)-Sum(v.MtoD_ME) As SaldoD
        ,Convert(bit,1) As Sel
	FROM 
		Voucher v
		Left Join Compra e On e.RucE=v.RucE and e.Cd_Prv=v.Cd_Prv and e.Cd_TD=v.Cd_TD and e.NroSre=v.NroSre and e.NroDoc=v.NroDoc
		Inner Join TipDoc t On t.Cd_TD=v.Cd_TD
	WHERE
		v.RucE=@RucE /*and v.Ejer='2012'*/ and v.Prdo not in ('00','13','14')
		and ISNULL(v.IB_Anulado, 0) = 0
		and ISNULL(v.Cd_Prv,'')=@Cd_Prv-- <> ''
		and v.Cd_Fte in ('RC','LD','CB')
		and v.Cd_TD <> '39'
		and isnull(e.Cd_Com,'')=''
		and isnull(v.NroDoc,'')<>''
	GROUP BY
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End,
		v.Cd_TD,v.NroSre,v.NroDoc,t.NCorto
	ORDER BY 1,2,3
	
	
	
	-- DETALLE --
	--***********************************************************************
	SELECT 
		Tb.DR_CdTD,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Com,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_TD,t.NCorto As NomTD,Tb.NroSre,Tb.NroDoc,
		Tb.Cd_Mda,
		Case When Tb.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		Tb.CamMda,
		Sum(Tb.TotalS) As SaldoS,Sum(Tb.TotalD) As SaldoD
		,Convert(bit,0) As Sel
    FROM 
    (
		SELECT 
				Case When isnull(DR_CdTD,'')<>'' Then DR_CdTD Else Cd_TD End As DR_CdTD,
				Case When isnull(DR_NSre,'')<>'' Then DR_NSre Else NroSre End As DR_NSre,
				Case When isnull(DR_NDoc,'')<>'' Then DR_NDoc Else NroDoc End As DR_NDoc,
				Cd_Com,'' AS Cd_Vou,'' AS Cd_Ltr,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda,
				CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), Total * CamMda) ELSE Total END AS TotalS, 
				CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
			FROM 
				Compra 
			WHERE 
				RucE=@RucE and ISNULL(IB_Anulado, 0) = 0 and ISNULL(Cd_Prv,'')=@Cd_Prv		
		
		UNION
		
		SELECT 
			Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
			Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
			Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
			r.Cd_Com,'' AS Cd_Vou,'' AS Cd_Ltr,v.Cd_TD,v.NroSre,v.NroDoc,r.Cd_Mda,r.CamMda,
			v.MtoH-v.MtoD As TotalS,v.MtoH_ME-v.MtoD_ME As TotalS
		FROM
			Voucher v
			Inner Join (
						SELECT RucE,Cd_Com,RegCtb,Cd_Prv,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda
						FROM Compra WHERE RucE=@RucE and ISNULL(IB_Anulado, 0)=0 and ISNULL(Cd_Prv,'')=@Cd_Prv	
						) r On r.RucE=v.RucE and r.Cd_Prv=v.Cd_Prv and r.Cd_TD=v.Cd_TD and r.NroSre=v.NroSre and r.NroDoc=v.NroDoc
	) AS Tb
	Inner Join TipDoc t On t.Cd_TD=Tb.Cd_TD
	Group by Tb.DR_CdTD,t.NCorto,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Com,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_TD,Tb.NroSre,Tb.NroDoc,Tb.Cd_Mda,Tb.CamMda
	Having	Sum(Tb.TotalS)+Sum(Tb.TotalD)<>0

	UNION ALL
	
	SELECT
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
		'' As Cd_Com,Convert(varchar,v.Cd_Vou) As Cd_Vou,'' As Cd_Ltr,
		v.Cd_TD,t.NCorto As NomTD,v.NroSre,v.NroDoc,v.Cd_MdOr As Cd_Mda,
		Case When v.Cd_MdOr='01' Then 'S/.' Else 'US$.' End As NomMda,
		v.CamMda,
		Sum(v.MtoH)-Sum(v.MtoD) As SaldoS, 
        Sum(v.MtoH_ME)-Sum(v.MtoD_ME) As SaldoD
        ,Convert(bit,0) As Sel
	FROM 
		Voucher v
		Left Join Compra e On e.RucE=v.RucE and e.Cd_Prv=v.Cd_Prv and e.Cd_TD=v.Cd_TD and e.NroSre=v.NroSre and e.NroDoc=v.NroDoc
		Inner Join TipDoc t On t.Cd_TD=v.Cd_TD
	WHERE
		v.RucE=@RucE /*and v.Ejer='2012'*/ and v.Prdo not in ('00','13','14')
		and ISNULL(v.IB_Anulado, 0) = 0
		and ISNULL(v.Cd_Prv,'')=@Cd_Prv-- <> ''
		and v.Cd_Fte in ('RC','LD','CB')
		and v.Cd_TD <> '39'
		and isnull(e.Cd_Com,'')=''
		and isnull(v.NroDoc,'')<>''
	GROUP BY
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End,
		v.Cd_Vou,v.Cd_TD,t.NCorto,v.NroSre,v.NroDoc,v.Cd_MdOr,v.CamMda
	ORDER BY 1,2,3
End

-- Leyenda --
-- DI : 16/08/2012 <Creacion del SP>
GO

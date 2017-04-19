SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAux3]

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
		-- GRUPO --
	--***********************************************************************
	SELECT
		Res.DR_CdTD,Res.DR_NSre,Res.DR_NDoc,Res.Cd_Vta,Res.Cd_Vou,Res.Cd_Ltr,
		Res.Cd_TD,Res.NomTD,Res.NroSre,Res.NroDoc,
		Res.Cd_Mda,Res.NomMda,Res.CamMda,
		Res.SaldoS-isnull(Ref.TotalS,0) As SaldoS,
		Res.SaldoD-isnull(Ref.TotalD,0) As SaldoD,
		Res.Sel
	FROM
	(
	SELECT
		Tb.DR_CdTD,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Vta,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.DR_CdTD As Cd_TD,t.NCorto As NomTD,Tb.DR_NSre As NroSre,Tb.DR_NDoc As NroDoc,
		Tb.Cd_Mda,
		'' As NomMda,
		Tb.CamMda,
		Sum(Tb.TotalS) As SaldoS,Sum(Tb.TotalD) As SaldoD,Convert(bit,0) As Sel
    FROM 
    (
		SELECT 
			Case When isnull(DR_CdTD,'')<>'' Then DR_CdTD Else Cd_TD End As DR_CdTD,
			Case When isnull(DR_NSre,'')<>'' Then DR_NSre Else NroSre End As DR_NSre,
			Case When isnull(DR_NDoc,'')<>'' Then DR_NDoc Else NroDoc End As DR_NDoc,
			'' As Cd_Vta,'' AS Cd_Vou,'' AS Cd_Ltr,Cd_TD,NroSre,NroDoc,'' As Cd_Mda,'' As CamMda,
			CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), Total * CamMda) ELSE Total END AS TotalS, 
			CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
		FROM 
			Venta 
		WHERE 
			RucE=@RucE and ISNULL(IB_Anulado, 0) = 0 and ISNULL(Cd_Clt,'')=@Cd_Clt
			
		UNION
		
		SELECT 
			Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
			Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
			Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
			'' As Cd_Vta,'' AS Cd_Vou,'' AS Cd_Ltr,v.Cd_TD,v.NroSre,v.NroDoc,'' As Cd_Mda,'' As CamMda,
			v.MtoD-v.MtoH As TotalS,v.MtoD_ME-v.MtoH_ME As TotalS
		FROM
			Voucher v
			Inner Join (
						SELECT RucE,Cd_Vta,RegCtb,Cd_Clt,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda
						FROM Venta WHERE RucE=@RucE and ISNULL(IB_Anulado, 0)=0 and ISNULL(Cd_Clt,'')=@Cd_Clt
						) r On r.RucE=v.RucE and r.Cd_Clt=v.Cd_Clt and r.Cd_TD=v.Cd_TD and r.NroSre=v.NroSre and r.NroDoc=v.NroDoc

	) AS Tb
	Inner Join TipDoc t On t.Cd_TD=Tb.DR_CdTD
	Group by Tb.DR_CdTD,t.NCorto,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Vta,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_Mda,Tb.CamMda
	Having	Sum(Tb.TotalS)+Sum(Tb.TotalD)<>0
	) AS Res
	Left Join (	Select 
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_CdTD,v.Cd_TD) Else isnull(p.DR_CdTD,p.Cd_TD) End As Cd_TD,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NSre,v.NroSre) Else isnull(p.DR_NSre,p.NroSre) End As NroSre,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NDoc,v.NroDoc) Else isnull(p.DR_NDoc,p.NroDoc) End As NroDoc,
					Sum(Case When d.Cd_Mda='01' Then d.Total Else Convert(decimal(13,2),d.Total*c.TipCam) End) As TotalS,
					Sum(Case When d.Cd_Mda='02' Then d.Total Else Convert(decimal(13,2),d.Total/c.TipCam) End) As TotalD
				From 
					CanjeDet d
					Inner Join Canje c On c.RucE=d.RucE and c.Cd_Cnj=d.Cd_Cnj
					Left Join Venta p On p.RucE=d.RucE and p.Cd_Vta=d.Cd_Vta
					Left Join Voucher v On v.RucE=c.RucE and v.RegCtb=c.RegCtb
				Where
					d.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(v.RegCtb,'')=''
				Group by
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_CdTD,v.Cd_TD) Else isnull(p.DR_CdTD,p.Cd_TD) End,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NSre,v.NroSre) Else isnull(p.DR_NSre,p.NroSre) End,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NDoc,v.NroDoc) Else isnull(p.DR_NDoc,p.NroDoc) End
			  ) Ref On Ref.Cd_TD=Res.Cd_TD and Ref.NroSre=Res.NroSre and Ref.NroDoc=Res.NroDoc
	WHERE (Res.SaldoS - isnull(Ref.TotalS,0))+(Res.SaldoD - isnull(Ref.TotalD,0))<>0
	
	UNION ALL
	
	SELECT 
	Res.DR_CdTD,Res.DR_NSre,Res.DR_NDoc,Res.Cd_Vta,Res.Cd_Vou,Res.Cd_Ltr,Res.Cd_TD,Res.NomTD,Res.NroSre,Res.NroDoc,Res.Cd_Mda,Res.NomMda,Res.CamMda,
	Res.SaldoS-isnull(Ref.TotalS,0) As SaldoS,
	Res.SaldoD-isnull(Ref.TotalD,0) As SaldoD,
	Res.Sel
	FROM
	(
	SELECT
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
		'' As Cd_Vta,'' As Cd_Vou,'' As Cd_Ltr,
		v.Cd_TD,t.NCorto As NomTD,v.NroSre,v.NroDoc,'' As Cd_Mda,'' As NomMda,'' As CamMda,
		Sum(v.MtoD)-Sum(v.MtoH) As SaldoS, 
        Sum(v.MtoD_ME)-Sum(v.MtoH_ME) As SaldoD
        ,Convert(bit,0) As Sel
	FROM 
		Voucher v
		Left Join Venta e On e.RucE=v.RucE and e.Cd_Clt=v.Cd_Clt and e.Cd_TD=v.Cd_TD and e.NroSre=v.NroSre and e.NroDoc=v.NroDoc
		Inner Join TipDoc t On t.Cd_TD=v.Cd_TD
	WHERE
		v.RucE=@RucE /*and v.Ejer='2012'*/ and v.Prdo not in ('00','13','14')
		and ISNULL(v.IB_Anulado, 0) = 0
		and ISNULL(v.Cd_Clt,'')=@Cd_Clt-- <> ''
		and v.Cd_Fte in ('RV','LD','CB')
		and v.Cd_TD <> '39'
		and isnull(e.Cd_Vta,'')=''
		and isnull(v.NroDoc,'')<>''
	GROUP BY
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End,
		v.Cd_TD,v.NroSre,v.NroDoc,t.NCorto
	) AS Res
	Left Join (	Select 
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_CdTD,v.Cd_TD) Else isnull(p.DR_CdTD,p.Cd_TD) End As Cd_TD,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NSre,v.NroSre) Else isnull(p.DR_NSre,p.NroSre) End As NroSre,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NDoc,v.NroDoc) Else isnull(p.DR_NDoc,p.NroDoc) End As NroDoc,
					Sum(Case When d.Cd_Mda='01' Then d.Total Else Convert(decimal(13,2),d.Total*c.TipCam) End) As TotalS,
					Sum(Case When d.Cd_Mda='02' Then d.Total Else Convert(decimal(13,2),d.Total/c.TipCam) End) As TotalD
				From 
					CanjeDet d
					Inner Join Canje c On c.RucE=d.RucE and c.Cd_Cnj=d.Cd_Cnj
					Left Join Venta p On p.RucE=d.RucE and p.Cd_Vta=d.Cd_Vta
					Left Join Voucher v On v.RucE=c.RucE and v.RegCtb=c.RegCtb
				Where
					d.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(v.RegCtb,'')=''
				Group by
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_CdTD,v.Cd_TD) Else isnull(p.DR_CdTD,p.Cd_TD) End,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NSre,v.NroSre) Else isnull(p.DR_NSre,p.NroSre) End,
					Case When isnull(d.Cd_Vou,'')<>'' Then isnull(v.DR_NDoc,v.NroDoc) Else isnull(p.DR_NDoc,p.NroDoc) End
			  ) AS Ref On Ref.Cd_TD=Res.Cd_TD and Ref.NroSre=Res.NroSre and Ref.NroDoc=Res.NroDoc
	WHERE (Res.SaldoS - isnull(Ref.TotalS,0))+(Res.SaldoD - isnull(Ref.TotalD,0))<>0
	ORDER BY 1,2,3
	
	
	-- DETALLE --
	--***********************************************************************
	SELECT
		Res.DR_CdTD,Res.DR_NSre,Res.DR_NDoc,Res.Cd_Vta,Res.Cd_Vou,Res.Cd_Ltr,
		Res.Cd_TD,Res.NomTD,Res.NroSre,Res.NroDoc,
		Res.Cd_Mda,Res.NomMda,Res.CamMda,
		Res.SaldoS-isnull(Ref.TotalS,0) As SaldoS,
		Res.SaldoD-isnull(Ref.TotalD,0) As SaldoD,
		Res.Sel
	FROM
	(
	SELECT 
		Tb.DR_CdTD,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Vta,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_TD,t.NCorto As NomTD,Tb.NroSre,Tb.NroDoc,
		Tb.Cd_Mda,
		Case When Tb.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		Tb.CamMda,Sum(Tb.TotalS) As SaldoS,Sum(Tb.TotalD) As SaldoD,Convert(bit,0) As Sel
    FROM 
    (
		SELECT 
				Case When isnull(DR_CdTD,'')<>'' Then DR_CdTD Else Cd_TD End As DR_CdTD,
				Case When isnull(DR_NSre,'')<>'' Then DR_NSre Else NroSre End As DR_NSre,
				Case When isnull(DR_NDoc,'')<>'' Then DR_NDoc Else NroDoc End As DR_NDoc,
				Cd_Vta,'' AS Cd_Vou,'' AS Cd_Ltr,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda,
				CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), Total * CamMda) ELSE Total END AS TotalS, 
				CASE WHEN Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
			FROM 
				Venta 
			WHERE 
				RucE=@RucE and ISNULL(IB_Anulado, 0) = 0 and ISNULL(Cd_Clt,'')=@Cd_Clt	
		
		UNION
		
		SELECT 
			Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
			Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
			Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
			r.Cd_Vta,'' AS Cd_Vou,'' AS Cd_Ltr,v.Cd_TD,v.NroSre,v.NroDoc,r.Cd_Mda,r.CamMda,
			v.MtoD-v.MtoH As TotalS,v.MtoD_ME-v.MtoH_ME As TotalS
		FROM
			Voucher v
			Inner Join (
						SELECT RucE,Cd_Vta,RegCtb,Cd_Clt,Cd_TD,NroSre,NroDoc,Cd_Mda,CamMda
						FROM Venta WHERE RucE=@RucE and ISNULL(IB_Anulado, 0)=0 and ISNULL(Cd_Clt,'')=@Cd_Clt
						) r On r.RucE=v.RucE and r.Cd_Clt=v.Cd_Clt and r.Cd_TD=v.Cd_TD and r.NroSre=v.NroSre and r.NroDoc=v.NroDoc
	) AS Tb
	Inner Join TipDoc t On t.Cd_TD=Tb.Cd_TD
	Group by Tb.DR_CdTD,t.NCorto,Tb.DR_NSre,Tb.DR_NDoc,Tb.Cd_Vta,Tb.Cd_Vou,Tb.Cd_Ltr,Tb.Cd_TD,Tb.NroSre,Tb.NroDoc,Tb.Cd_Mda,Tb.CamMda
	Having	Sum(Tb.TotalS)+Sum(Tb.TotalD)<>0
	) AS Res
	Left Join (	Select 
					Case When isnull(d.Cd_Vta,'')<>'' Then p.Cd_TD Else d.Cd_TD End As Cd_TD,
					Case When isnull(d.Cd_Vta,'')<>'' Then p.NroSre Else d.NroSre End As NroSre,
					Case When isnull(d.Cd_Vta,'')<>'' Then p.NroDoc Else d.NroDoc End As NroDoc,
					Case When d.Cd_Mda='01' Then d.Total Else Convert(decimal(13,2),d.Total*c.TipCam) End As TotalS,
					Case When d.Cd_Mda='02' Then d.Total Else Convert(decimal(13,2),d.Total/c.TipCam) End As TotalD
				From 
					CanjeDet d
					Inner Join Canje c On c.RucE=d.RucE and c.Cd_Cnj=d.Cd_Cnj
					Left Join Venta p On p.RucE=d.RucE and p.Cd_Vta=d.Cd_Vta
					Left Join Voucher v On v.RucE=c.RucE and v.RegCtb=c.RegCtb
				Where
					d.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(v.RegCtb,'')=''
			  ) Ref On Ref.Cd_TD=Res.Cd_TD and Ref.NroSre=Res.NroSre and Ref.NroDoc=Res.NroDoc
	WHERE (Res.SaldoS - isnull(Ref.TotalS,0))+(Res.SaldoD - isnull(Ref.TotalD,0))<>0
	
	UNION ALL
	
	SELECT 
	Res.DR_CdTD,Res.DR_NSre,Res.DR_NDoc,Res.Cd_Vta,Res.Cd_Vou,Res.Cd_Ltr,Res.Cd_TD,Res.NomTD,Res.NroSre,Res.NroDoc,Res.Cd_Mda,Res.NomMda,Res.CamMda,
	Res.SaldoS-isnull(Ref.TotalS,0) As SaldoS,
	Res.SaldoD-isnull(Ref.TotalD,0) As SaldoD,
	Res.Sel
	FROM
	(
	SELECT
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End As DR_CdTD,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End As DR_NSre,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End As DR_NDoc,
		'' As Cd_Vta,Convert(varchar,v.Cd_Vou) AS Cd_Vou,'' As Cd_Ltr,
		v.Cd_TD,t.NCorto As NomTD,v.NroSre,v.NroDoc,
		v.Cd_MdOr As Cd_Mda,
		Case When v.Cd_MdOr='01' Then 'S/.' Else 'US$.' End As NomMda,
		v.CamMda,
		Sum(v.MtoD)-Sum(v.MtoH) As SaldoS, 
        Sum(v.MtoD_ME)-Sum(v.MtoH_ME) As SaldoD
        ,Convert(bit,0) As Sel
	FROM 
		Voucher v
		Left Join Venta e On e.RucE=v.RucE and e.Cd_Clt=v.Cd_Clt and e.Cd_TD=v.Cd_TD and e.NroSre=v.NroSre and e.NroDoc=v.NroDoc
		Inner Join TipDoc t On t.Cd_TD=v.Cd_TD
	WHERE
		v.RucE=@RucE /*and v.Ejer='2012'*/ and v.Prdo not in ('00','13','14')
		and ISNULL(v.IB_Anulado, 0) = 0
		and ISNULL(v.Cd_Clt,'')=@Cd_Clt-- <> ''
		and v.Cd_Fte in ('RV','LD','CB')
		and v.Cd_TD <> '39'
		and isnull(e.Cd_Vta,'')=''
		and isnull(v.NroDoc,'')<>''
	GROUP BY
		Case When isnull(v.DR_CdTD,'')<>'' Then v.DR_CdTD Else v.Cd_TD End,
		Case When isnull(v.DR_NSre,'')<>'' Then v.DR_NSre Else v.NroSre End,
		Case When isnull(v.DR_NDoc,'')<>'' Then v.DR_NDoc Else v.NroDoc End,
		v.Cd_Vou,v.Cd_TD,t.NCorto,v.NroSre,v.NroDoc,v.Cd_MdOr,v.CamMda
	) AS Res
	Left Join (	Select 
					Case When isnull(d.Cd_Vta,'')<>'' Then p.Cd_TD Else d.Cd_TD End As Cd_TD,
					Case When isnull(d.Cd_Vta,'')<>'' Then p.NroSre Else d.NroSre End As NroSre,
					Case When isnull(d.Cd_Vta,'')<>'' Then p.NroDoc Else d.NroDoc End As NroDoc,
					Case When d.Cd_Mda='01' Then d.Total Else Convert(decimal(13,2),d.Total*c.TipCam) End As TotalS,
					Case When d.Cd_Mda='02' Then d.Total Else Convert(decimal(13,2),d.Total/c.TipCam) End As TotalD
				From 
					CanjeDet d
					Inner Join Canje c On c.RucE=d.RucE and c.Cd_Cnj=d.Cd_Cnj
					Left Join Venta p On p.RucE=d.RucE and p.Cd_Vta=d.Cd_Vta
					Left Join Voucher v On v.RucE=c.RucE and v.RegCtb=c.RegCtb
				Where
					d.RucE=@RucE and c.Cd_Clt=@Cd_Clt and isnull(v.RegCtb,'')=''
			  ) AS Ref On Ref.Cd_TD=Res.Cd_TD and Ref.NroSre=Res.NroSre and Ref.NroDoc=Res.NroDoc
	WHERE (Res.SaldoS - isnull(Ref.TotalS,0))+(Res.SaldoD - isnull(Ref.TotalD,0))<>0
	ORDER BY 1,2,3
	
End

-- Leyenda --
-- DI : 16/08/2012 <Creacion del SP>
GO

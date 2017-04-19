SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_LtrCtasCorrientes2]
--declare 
@RucE nvarchar(11),@Ejer nvarchar(4), @Cd_Mda nchar(2),@FecIni datetime,@FecFin datetime,@Cd_Clt nvarchar(11)
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @Cd_Mda = ''
--set @FecIni = '01/01/2012'
--set @FecFin = '31/03/2012'
--set @Cd_Clt = 'CLT0000009'
as
------Datos Generales-------
select RSocial,Direccion,Ruc,Telef,'Del '+CONVERT(nvarchar,@FecIni,103) +' al '+CONVERT(nvarchar,@FecFin,103) as Desde,
case when @Cd_Mda='01' then 'EXPRESADO EN NUEVOS SOLES'  else 'EXPRESADO EN DOLARES AMERICANOS'end as Moneda from Empresa Where Ruc = @RucE


------Fin Generales---------


--Cliente--
select c.Cd_Clt, c.RucE , 
case when isnull(clt.Rsocial,'')='' then clt.ApPat + ' ' + clt.ApMat +' '+clt.Nom else clt.RSocial end as Cliente 
,clt.Direc
,clt.NDoc

from 
(
	select 
		doc.Cd_Clt,doc.RucE
	from
	(	
		Select d.* From 
		(
			SELECT DISTINCT 
                      v.RucE, c.Ejer, '' AS Cd_Vta, CONVERT(varchar, v.Cd_Ltr) AS Cd_Ltr, c.RegCtb, c.Cd_Clt, 39 AS Cd_TD, '' AS NroSre, ISNULL(v.NroRenv, '') + v.NroLtr AS NroDoc, 
                      c.Cd_Mda, c.TipCam AS CamMda, CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END AS TotalS, 
                      CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END AS TotalD
                      ,v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10
                      ,0.00 as MtoD,0.00 as MtoH,0.00 as MtoD_ME,0.00 as MtoH_ME
                      ,null as FecCbr
					  ,null as FecED
					  ,convert(nvarchar,v.FecGiro,103) as FecMov
					  ,convert(nvarchar,v.FecVenc,103) as FecVD
			FROM dbo.Letra_Cobro AS v LEFT JOIN
            dbo.Canje AS c ON c.RucE = v.RucE AND c.Cd_Cnj = v.Cd_Cnj
		)as d Where d.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then d.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		Union All
		Select c.* from 
		(
			SELECT		v.RucE, v.Ejer, ISNULL(t.Cd_Vta, N'') AS Cd_Vta, '' AS Cd_Ltr, v.RegCtb, v.Cd_Clt, v.Cd_TD, v.NroSre, v.NroDoc, v.Cd_MdRg AS Cd_Mda, v.CamMda, 
						v.MtoD - v.MtoH AS TotalS, v.MtoD_ME - v.MtoH_ME AS TotalD
						,'' as CA01,'' as CA02,'' as CA03,'' as CA04,'' as CA05,'' as CA06,'' as CA07,'' as CA08,'' as CA09,'' as CA10
						,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME
						,Convert(nvarchar,v.FecCbr,103) as FecCbr
						,Convert(nvarchar,v.FecED,103) as FecED
						,Convert(nvarchar,v.FecMov,103) as FecMov
						,Convert(nvarchar,v.FecVD,103) as FecVD
			FROM         dbo.Voucher AS v LEFT OUTER JOIN
								  dbo.Venta AS t ON t.RucE = v.RucE AND t.Cd_TD = v.Cd_TD AND t.NroSre = v.NroSre AND t.NroDoc = v.NroDoc
			WHERE     (v.Cd_Fte IN ('CB'))
		)as c where c.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in 
		(
			Select c.Cd_Ltr From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0
		)
		and doc.Cd_Ltr not in 
		(
			Select l.Cd_Ltr From Canje c Inner Join Letra_Cobro l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@cd_Clt,'') /*c.Cd_Clt=@Cd_Clt*/ and isnull(c.IB_Anulado,0)=1
		)
		and doc.FecMov between @FecIni and @FecFin
	Group by doc.Cd_Clt,doc.RucE
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
union	
select 
		doc.Cd_Clt,doc.RucE
	from
	(	
		SELECT     v.RucE, v.Ejer, ISNULL(t.Cd_Vta,'') AS Cd_Vta, '' AS Cd_Ltr, t.RegCtb, v.Cd_Clt, v.Cd_TD, v.NroSre, v.NroDoc, v.Cd_MdRg AS Cd_Mda, v.CamMda, 
					  v.MtoD, v.MtoH ,v.MtoD - v.MtoH AS TotalS, v.MtoD_ME , v.MtoH_ME,v.MtoD_ME - v.MtoH_ME AS TotalD
					  ,null as FecCbr
					  ,null as FecED
					  ,null as FecMov
					  ,null as FecVD
		FROM         dbo.Voucher AS v LEFT JOIN
					  dbo.Venta AS t ON t.RucE = v.RucE AND t.Cd_TD = v.Cd_TD AND t.NroSre = v.NroSre AND t.NroDoc = v.NroDoc
		WHERE     (v.Cd_Fte IN ('CB', 'LD')) AND (v.RegCtb NOT LIKE 'LT%') 
					and v.RucE = @RucE--'11111111111' 
					--and Cd_Clt = 'CLT0003645'
					and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
		union
		SELECT DISTINCT 
					  RucE, Eje AS Ejer, Cd_Vta, '' AS Cd_Ltr, RegCtb, Cd_Clt, Cd_TD, NroSre, NroDoc, Cd_Mda, CamMda, 
					  0.0 as MtoD, 0.0 as MtoH,
					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13,2), Total * CamMda) ELSE Total END AS TotalS, 
					  0.0 as MtoD_ME, 0.0 as MtoH_ME,
					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
					  ,Convert(nvarchar,v.FecCbr,103) as FecCbr
					  ,Convert(nvarchar,v.FecED,103) as FecED
					  ,Convert(nvarchar,v.FecMov,103) as FecMov
					  ,Convert(nvarchar,v.FecVD,103) as FecVD
		FROM         dbo.Venta AS v
		where RucE = @RucE--'11111111111' 
		--and Cd_Clt = 'CLT0003645'
		and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
	doc.Cd_Vta not in
	(
	Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	Where c.RucE='11111111111'/*@RucE*/ 
	and isnull(c.Cd_Vta,'')<>''
	)
	and doc.FecMov between @FecIni and @FecFin
	Group by doc.RucE,doc.Cd_Clt
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
) as c 
Left join Cliente2 clt on c.Cd_Clt = clt.Cd_Clt and c.RucE = clt.RucE
where case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@Cd_Clt,'')
group by c.Cd_clt,c.rucE, case when isnull(clt.Rsocial,'')='' then clt.ApPat + ' ' + clt.ApMat +' '+clt.Nom else clt.RSocial end ,clt.Direc
,clt.NDoc
order by Cliente
----Fin Cliente--------




---Documentos-----------

		select * from 
(
		select
		doc.Cd_Vta, 
		doc.Cd_Clt,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc,doc.Cd_Mda
		,sum(doc.MtoD) as MtoD
		,sum(doc.MtoH) as MtoH
		,sum(doc.MtoD_ME) as MtoD_ME
		,sum(doc.MtoH_ME) as MtoH_ME
		,Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda
		,doc.CamMda
		,sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Max(doc.FecCbr) as FecCbr
		,Max(doc.FecED) as FecED
		,Max(doc.FecMov) as FecMov
		,Max(doc.FecVD) as FecVD
		--,case when ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) ='' then null else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) end SaldoDias
		,case when 
			ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) ='' 
			then null else case when 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')))<0 then null 
			else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) end   end SaldoDias
		,case ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) 
		when '' then '' 
		else case when DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) <= 0 then 'Venc.' end end as Est
		,@Cd_Mda as Cd_MdCons
	from
	(	
		SELECT     v.RucE, v.Ejer, ISNULL(t.Cd_Vta,'') AS Cd_Vta, '' AS Cd_Ltr, t.RegCtb, v.Cd_Clt, v.Cd_TD, v.NroSre, v.NroDoc, v.Cd_MdRg AS Cd_Mda, v.CamMda, 
					  v.MtoD, v.MtoH ,v.MtoD - v.MtoH AS TotalS, v.MtoD_ME , v.MtoH_ME,v.MtoD_ME - v.MtoH_ME AS TotalD
					  ,null as FecCbr
					  ,null as FecED
					  ,null as FecMov
					  ,null as FecVD
		FROM         dbo.Voucher AS v LEFT JOIN
					  dbo.Venta AS t ON t.RucE = v.RucE AND t.Cd_TD = v.Cd_TD AND t.NroSre = v.NroSre AND t.NroDoc = v.NroDoc
		WHERE     (v.Cd_Fte IN ('CB', 'LD')) AND (v.RegCtb NOT LIKE 'LT%') 
					and v.RucE = @RucE--'11111111111' 
					--and Cd_Clt = 'CLT0003645'
					and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
		union
		SELECT DISTINCT 
					  RucE, Eje AS Ejer, Cd_Vta, '' AS Cd_Ltr, RegCtb, Cd_Clt, Cd_TD, NroSre, NroDoc, Cd_Mda, CamMda, 
					  0.0 as MtoD, 0.0 as MtoH,
					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13,2), Total * CamMda) ELSE Total END AS TotalS, 
					  0.0 as MtoD_ME, 0.0 as MtoH_ME,
					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
					  ,Convert(nvarchar,v.FecCbr,103) as FecCbr
					  ,Convert(nvarchar,v.FecED,103) as FecED
					  ,Convert(nvarchar,v.FecMov,103) as FecMov
					  ,Convert(nvarchar,v.FecVD,103) as FecVD
		FROM         dbo.Venta AS v
		where RucE = @RucE--'11111111111' 
		--and Cd_Clt = 'CLT0003645'
		and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
	doc.Cd_Vta not in
	(
	Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
	Where c.RucE='11111111111'/*@RucE*/ 
	and isnull(c.Cd_Vta,'')<>''
	)
	Group by doc.Cd_Vta, doc.RucE,doc.Cd_Vta,doc.Cd_Clt,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda
	,doc.CamMda
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
) as t
where t.FecMov between @FecIni and @FecFin
	
------Fin Documentos------


------Letras--------------
select * from
(
		select 
		doc.Cd_Clt ,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Max(doc.CA01) as CA01,Max(doc.CA02) as CA02
		,Max(doc.CA03) as CA03,Max(doc.CA04) as CA04
		,Max(doc.CA05) as CA05,Max(doc.CA06) as CA06
		,Max(doc.CA07) as CA07,Max(doc.CA08) as CA08
		,Max(doc.CA09) as CA09,Max(doc.CA10) as CA10
		,sum(doc.MtoD) as MtoD,sum(doc.MtoH) as MtoH
		,sum(doc.MtoD_ME) as MtoD_ME,sum(doc.MtoH_ME) as MtoH_ME
		--,Max(doc.FecCbr) as FecCbr
		--,Max(doc.FecED) as FecED
		--,Max(doc.FecMov) as FecMov
		--,Max(doc.FecVD) as FecVD
		,doc.FecCbr
		,doc.FecED
		,doc.FecMov
		,doc.FecVD
		,case when 
			ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) ='' 
			then null else case when 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')))<0 then null 
			else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) end   end SaldoDias
		,case ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) 
		when '' then '' 
		else case when DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) <= 0 then 'Venc.' end end as Est
		,@Cd_Mda as Cd_MdCons

	from
	(	
		Select d.* From 
		(
			SELECT DISTINCT 
                      v.RucE, c.Ejer, '' AS Cd_Vta, CONVERT(varchar, v.Cd_Ltr) AS Cd_Ltr, c.RegCtb, c.Cd_Clt, 39 AS Cd_TD, '' AS NroSre, ISNULL(v.NroRenv, '') + v.NroLtr AS NroDoc, 
                      c.Cd_Mda, c.TipCam AS CamMda, CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END AS TotalS, 
                      CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END AS TotalD
                      ,v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10
                      ,0.00 as MtoD,0.00 as MtoH,0.00 as MtoD_ME,0.00 as MtoH_ME
                      ,null as FecCbr
					  ,null as FecED
					  ,convert(nvarchar,v.FecGiro,103) as FecMov
					  ,convert(nvarchar,v.FecVenc,103) as FecVD
			FROM dbo.Letra_Cobro AS v LEFT JOIN
            dbo.Canje AS c ON c.RucE = v.RucE AND c.Cd_Cnj = v.Cd_Cnj
		)as d Where d.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then d.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		Union
		Select c.* from 
		(
			SELECT		v.RucE, v.Ejer, ISNULL(t.Cd_Vta, N'') AS Cd_Vta, '' AS Cd_Ltr, v.RegCtb, v.Cd_Clt, v.Cd_TD, v.NroSre, v.NroDoc, v.Cd_MdRg AS Cd_Mda, v.CamMda, 
						v.MtoD - v.MtoH AS TotalS, v.MtoD_ME - v.MtoH_ME AS TotalD
						,'' as CA01,'' as CA02,'' as CA03,'' as CA04,'' as CA05,'' as CA06,'' as CA07,'' as CA08,'' as CA09,'' as CA10
						,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME
						,Convert(nvarchar,v.FecCbr,103) as FecCbr
						,Convert(nvarchar,v.FecED,103) as FecED
						,Convert(nvarchar,v.FecMov,103) as FecMov
						,Convert(nvarchar,v.FecVD,103) as FecVD
			FROM         dbo.Voucher AS v LEFT OUTER JOIN
								  dbo.Venta AS t ON t.RucE = v.RucE AND t.Cd_TD = v.Cd_TD AND t.NroSre = v.NroSre AND t.NroDoc = v.NroDoc
			WHERE     (v.Cd_Fte IN ('CB'))
		)as c where c.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		and Cd_TD='39'
	) as doc
	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
	Where
		doc.Cd_Ltr not in 
		(
			Select c.Cd_Ltr From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0
		)
		and doc.Cd_Ltr not in 
		(
			Select l.Cd_Ltr From Canje c Inner Join Letra_Cobro l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@cd_Clt,'') /*c.Cd_Clt=@Cd_Clt*/ and isnull(c.IB_Anulado,0)=1
		)
	Group by doc.RegCtb,doc.Cd_Vta,doc.Cd_Clt,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
		,doc.FecCbr
		,doc.FecED
		,doc.FecMov
		,doc.FecVD
	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
) as t
where t.FecMov between @FecIni and @FecFin

------Fin Letras-----------

--<JA: 11/03/2012> Creacion del SP
--exec Rpt_LtrCtasCorrientes2 '11111111111','2011','01','01/01/2011','29/03/2012','CLT0003645'




GO

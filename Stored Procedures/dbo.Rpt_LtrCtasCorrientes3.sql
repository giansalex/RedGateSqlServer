SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_LtrCtasCorrientes3]
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

select c.Cd_Clt, 
case when isnull(clt.Rsocial,'')='' then clt.ApPat + ' ' + clt.ApMat +' '+clt.Nom else clt.RSocial end as Cliente 
,clt.Direc
,clt.NDoc

from 
(
/**************/
	select 
doc.Cd_Clt
from 
(
select
v.Cd_Clt,
v.Cd_TD,
td.NCorto as NCorto,
v.NroSre,
v.NroDoc,
v.Cd_MdRg as Cd_Mda,
sum(v.MtoD) as MtoD,
sum(v.MtoH) as MtoH,
sum(v.MtoD_ME) as MtoD_ME,
sum(v.MtoH_ME) as MtoH_ME,
Case When v.Cd_MdRg ='01' Then 'S/.' Else 'US$.' End As NomMda,
v.CamMda,
sum(v.MtoD-v.MtoH) as SaldoS,
sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecCbr,103) else '' end) as FecCbr,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecED,103) else '' end) as FecED,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecMov,103) else '' end) as FecMov,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecVD,103) else '' end) as FecVd
from Voucher v
inner join
(
	Select 
	v.RucE,	
	v.Ejer,	
	isnull(v.Cd_Clt,'') As Cd_Clt,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroDoc,'') As NroDoc
	From Voucher v 
	Where  v.RucE=@RucE 
			and isnull(v.IB_Anulado,0)<>1
			and v.Cd_TD not in ('39','LE')
			and v.Cd_Fte <> 'CB'
			and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@cd_Clt,'') 
			and v.IB_Anulado <> 1
	Group by v.RucE, v.Ejer, isnull(v.Cd_Clt,''), isnull(v.Cd_TD,''),ISNULL(v.NroSre,'') ,isnull(v.NroDoc,'')
	--having sum(MtoD-MtoH) != 0 and sum(MtoD_ME-MtoH_ME)!= 0
	having case when @Cd_Mda = '01' then sum(MtoD-MtoH) when @Cd_Mda = '02' then sum(MtoD_ME-MtoH_ME) else sum(MtoD-MtoH)+sum(MtoD_ME-MtoH_ME) end <> 0
) as t on t.RucE = v.RucE and t.Ejer = v.Ejer and t.Cd_Clt = v.Cd_Clt and t.Cd_TD = v.Cd_TD and t.NroDoc = v.NroDoc
Inner Join TipDoc td On td.Cd_TD=v.Cd_TD
where v.RucE = @RucE and v.IB_Anulado <> 1
group by 
v.RucE,v.Ejer,
td.NCorto,
v.Cd_TD,v.NroSre,v.NroDoc,
v.Cd_Clt,v.Cd_MdRg,v.CamMda
--Having SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME)!=0
Having case when @Cd_Mda = '01' then SUM(v.MtoD-MtoH) when @Cd_Mda = '02' then SUM(v.MtoD_ME-v.MtoH_ME) else  SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME) end <>0

) as doc
where 
isnull(doc.Cd_TD,'')+ISNULL(doc.NroSre,'')+ISNULL(doc.NroDoc,'') not in
(
	select isnull(v.Cd_TD,'')+ISNULL(v.NroSre,'')+ISNULL(v.NroDoc,'') From CanjeDet c 
		Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
		inner join Venta v on v.Cd_Vta = c.Cd_Vta and c.RucE = v.RucE
	where c.RucE = @RucE
)and 

doc.FecMov between @FecIni and @FecFin
/*************/
union
/***************/
select t.Cd_Clt from
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
                      c.Cd_Mda, c.TipCam AS CamMda, 
                      CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END AS TotalS, 
                      CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END AS TotalD
                      ,v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10
                      ,CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END as MtoD
                      ,0.00 as MtoH
                      ,CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END as MtoD_ME
                      ,0.00 as MtoH_ME
                      ,null as FecCbr
					  ,null as FecED
					  ,convert(nvarchar,v.FecGiro,103) as FecMov
					  ,convert(nvarchar,v.FecVenc,103) as FecVD
			FROM dbo.Letra_Cobro AS v LEFT JOIN
            dbo.Canje AS c ON c.RucE = v.RucE AND c.Cd_Cnj = v.Cd_Cnj
		)as d Where d.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then d.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		Union
		select
v.RucE,
v.Ejer,
'' as Cd_Vta,
'' as Cd_Ltr,
'' as RegCtb,
v.Cd_Clt,
v.Cd_TD,
'' as NroSre,
v.NroDoc,
v.Cd_MdRg as Cd_Mda,
v.CamMda,
sum(v.MtoD-v.MtoH) as TotalS,
sum(v.MtoD_ME-v.MtoH_ME) as TotalD,
'' as CA01,
'' as CA02,
'' as CA03,
'' as CA04,
'' as CA05,
'' as CA06,
'' as CA07,
'' as CA08,
'' as CA09,
'' as CA010,
sum(v.MtoD) as Monto,
sum(v.MtoH) as Cobrado,
sum(v.MtoD_ME) as Monto_ME,
sum(v.MtoH_ME) as Cobrado_ME,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecCbr,103) else '' end as FecCbr,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecED,103) else '' end as FecED,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecMov,103) else '' end as FecMov,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecVD,103) else '' end as FecVd
from Voucher v
inner join
(
Select 
v.RucE,	
v.Ejer,	
isnull(v.Cd_Clt,'') As Cd_Clt,
isnull(v.Cd_TD,'') As Cd_TD,
isnull(v.NroDoc,'') As NroDoc
From Voucher v 
Where  v.RucE=@RucE 
		--and v.Ejer=@Ejer 
		and isnull(v.IB_Anulado,0)<>1
		and v.Cd_TD = '39' 
		--and v.Cd_Clt = @Cd_Clt
		and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@cd_Clt,'') 
Group by v.RucE, v.Ejer, isnull(v.Cd_Clt,''), isnull(v.Cd_TD,''), isnull(v.NroDoc,'')
having sum(MtoD-MtoH) != 0 and sum(MtoD_ME-MtoH_ME)!= 0
--having case when @Cd_Mda = '01' then sum(MtoD-MtoH) when @Cd_Mda = '02' then sum(MtoD_ME-MtoH_ME) else sum(MtoD-MtoH)+sum(MtoD_ME-MtoH_ME) end <> 0
) as t on t.RucE = v.RucE and t.Ejer = v.Ejer and t.Cd_Clt = v.Cd_Clt and t.Cd_TD = v.Cd_TD and t.NroDoc = v.NroDoc
where v.RucE = @RucE 
		--and v.FecMov between @FecIni and @FecFin
group by 
v.RucE,v.Ejer,
v.Cd_TD,v.NroDoc,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecCbr,103) else '' end ,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecED,103) else '' end ,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecMov,103) else '' end ,
case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecVD,103) else '' end ,
v.Cd_Clt,v.Cd_MdRg,v.CamMda
Having SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME)!=0
--Having case when @Cd_Mda = '01' then SUM(v.MtoD-MtoH) when @Cd_Mda = '02' then SUM(v.MtoD_ME-v.MtoH_ME) else  SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME) end <>0

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
/***************/
) as c 
Left join Cliente2 clt on c.Cd_Clt = clt.Cd_Clt and clt.RucE = @RucE
where case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@Cd_Clt,'')
group by c.Cd_clt, case when isnull(clt.Rsocial,'')='' then clt.ApPat + ' ' + clt.ApMat +' '+clt.Nom else clt.RSocial end ,clt.Direc
,clt.NDoc
order by Cd_Clt

--Cliente--

----Fin Cliente--------




---Documentos-----------

--select * from 
--	(
--		select
--		doc.Cd_Vta, 
--		doc.Cd_Clt,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc,doc.Cd_Mda
--		,sum(doc.MtoD) as MtoD
--		,sum(doc.MtoH) as MtoH
--		,sum(doc.MtoD_ME) as MtoD_ME
--		,sum(doc.MtoH_ME) as MtoH_ME
--		,Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda
--		,doc.CamMda
--		,sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
--		,Max(doc.FecCbr) as FecCbr
--		,Max(doc.FecED) as FecED
--		,Max(doc.FecMov) as FecMov
--		,Max(doc.FecVD) as FecVD
--		--,case when ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) ='' then null else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) end SaldoDias
--		,case when 
--			ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) ='' 
--			then null else case when 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')))<0 then null 
--			else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) end   end SaldoDias
--		,case ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) 
--		when '' then '' 
--		else case when DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),''))) <= 0 then 'Venc.' end end as Est
--		,@Cd_Mda as Cd_MdCons
--	from
--	(	
--		SELECT     v.RucE, v.Ejer, ISNULL(t.Cd_Vta,'') AS Cd_Vta, '' AS Cd_Ltr, t.RegCtb, v.Cd_Clt, v.Cd_TD, v.NroSre, v.NroDoc, v.Cd_MdRg AS Cd_Mda, v.CamMda, 
--					  v.MtoD, v.MtoH ,v.MtoD - v.MtoH AS TotalS, v.MtoD_ME , v.MtoH_ME,v.MtoD_ME - v.MtoH_ME AS TotalD
--					  ,null as FecCbr
--					  ,null as FecED
--					  ,null as FecMov
--					  ,null as FecVD
--		FROM         dbo.Voucher AS v LEFT JOIN
--					  dbo.Venta AS t ON t.RucE = v.RucE AND t.Cd_TD = v.Cd_TD AND t.NroSre = v.NroSre AND t.NroDoc = v.NroDoc
--		WHERE     (v.Cd_Fte IN ('CB', 'LD')) AND (v.RegCtb NOT LIKE 'LT%') 
--					and v.RucE = @RucE--'11111111111' 
--					--and Cd_Clt = 'CLT0003645'
--					and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
--		union
--		SELECT DISTINCT 
--					  RucE, Eje AS Ejer, Cd_Vta, '' AS Cd_Ltr, RegCtb, Cd_Clt, Cd_TD, NroSre, NroDoc, Cd_Mda, CamMda, 
--					  0.0 as MtoD, 0.0 as MtoH,
--					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN CONVERT(decimal(13,2), Total * CamMda) ELSE Total END AS TotalS, 
--					  0.0 as MtoD_ME, 0.0 as MtoH_ME,
--					  CASE WHEN isnull(Cd_Mda, '') = '02' THEN Total ELSE CASE WHEN CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), Total / CamMda) END END AS TotalD
--					  ,Convert(nvarchar,v.FecCbr,103) as FecCbr
--					  ,Convert(nvarchar,v.FecED,103) as FecED
--					  ,Convert(nvarchar,v.FecMov,103) as FecMov
--					  ,Convert(nvarchar,v.FecVD,103) as FecVD
--		FROM         dbo.Venta AS v
--		where RucE = @RucE--'11111111111' 
--		--and Cd_Clt = 'CLT0003645'
--		and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
--	) as doc
--	Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
--	Where
--	doc.Cd_Vta not in
--	(
--	Select c.Cd_Vta From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
--	Where c.RucE='11111111111'/*@RucE*/ 
--	and isnull(c.Cd_Vta,'')<>''
--	)
--	Group by doc.Cd_Vta, doc.RucE,doc.Cd_Vta,doc.Cd_Clt,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda
--	,doc.CamMda
--	Having sum(doc.TotalS)+sum(doc.TotalD)<>0
--) as t
--where t.FecMov between @FecIni and @FecFin
select 
doc.*
,case when ISNULL(doc.FecCbr,ISNULL(doc.FecVD,'')) ='' then null else case when 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(doc.FecCbr,ISNULL(doc.FecVD,'')))<0 then null else 1*-DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(doc.FecCbr,ISNULL(doc.FecVD,''))) end   end SaldoDias
,case ISNULL(doc.FecCbr,ISNULL(doc.FecVD,'')) when '' then '' else case when DATEDIFF(day,CONVERT(nvarchar,@FecFin,103),ISNULL(doc.FecCbr,ISNULL(doc.FecVD,''))) <= 0 then 'Venc.' end end as Est
,@Cd_Mda as Cd_MdCons 
from 
(
select
v.Cd_Clt,
v.Cd_TD,
td.NCorto as NCorto,
v.NroSre,
v.NroDoc,
v.Cd_MdRg as Cd_Mda,
sum(v.MtoD) as MtoD,
sum(v.MtoH) as MtoH,
sum(v.MtoD_ME) as MtoD_ME,
sum(v.MtoH_ME) as MtoH_ME,
Case When v.Cd_MdRg ='01' Then 'S/.' Else 'US$.' End As NomMda,
v.CamMda,
sum(v.MtoD-v.MtoH) as SaldoS,
sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecCbr,103) else '' end) as FecCbr,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecED,103) else '' end) as FecED,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecMov,103) else '' end) as FecMov,
max(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecVD,103) else '' end) as FecVd
from Voucher v
inner join
(
	Select 
	v.RucE,	
	v.Ejer,	
	isnull(v.Cd_Clt,'') As Cd_Clt,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroDoc,'') As NroDoc
	From Voucher v 
	Where  v.RucE=@RucE 
			and isnull(v.IB_Anulado,0)<>1
			and v.Cd_TD not in ('39','LE')
			--and v.Cd_Fte <> 'CB'
			and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@cd_Clt,'') 
	Group by v.RucE, v.Ejer, isnull(v.Cd_Clt,''), isnull(v.Cd_TD,''),ISNULL(v.NroSre,'') ,isnull(v.NroDoc,'')
	--having case when @Cd_Mda = '01' then sum(MtoD-MtoH) when @Cd_Mda = '02' then sum(MtoD_ME-MtoH_ME) else sum(MtoD-MtoH)+sum(MtoD_ME-MtoH_ME) end <> 0
	having sum(MtoD-MtoH) != 0 and sum(MtoD_ME-MtoH_ME)!= 0
) as t on t.RucE = v.RucE and t.Ejer = v.Ejer and t.Cd_Clt = v.Cd_Clt and t.Cd_TD = v.Cd_TD and t.NroDoc = v.NroDoc
Inner Join TipDoc td On td.Cd_TD=v.Cd_TD
left join Venta vt on vt.RucE = v.RucE and vt.Eje = v.Ejer and vt.Cd_TD = v.Cd_TD and vt.NroSre = v.NroSre and vt.NroDoc = v.NroDoc   
where v.RucE = @RucE and isnull(v.IB_Anulado,0)<>1  and vt.CA01<> 'DESARROLLO'
group by 
v.RucE,v.Ejer,
td.NCorto,
v.Cd_TD,v.NroSre,v.NroDoc,
v.Cd_Clt,v.Cd_MdRg,v.CamMda
--Having case when @Cd_Mda = '01' then SUM(v.MtoD-MtoH) when @Cd_Mda = '02' then SUM(v.MtoD_ME-v.MtoH_ME) else  SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME) end <>0
Having SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME)!=0
) as doc
where 
isnull(doc.Cd_TD,'')+ISNULL(doc.NroSre,'')+ISNULL(doc.NroDoc,'') not in
(
	select isnull(v.Cd_TD,'')+ISNULL(v.NroSre,'')+ISNULL(v.NroDoc,'') From CanjeDet c 
		Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 
		inner join Venta v on v.Cd_Vta = c.Cd_Vta and c.RucE = v.RucE
	where c.RucE = @RucE
)and 

doc.FecMov between @FecIni and @FecFin
	
------Fin Documentos------

------Letras---------------
		select * from
		(
		select 
		doc.Cd_Clt ,convert(varchar,doc.Cd_TD) As Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc,doc.Cd_Mda,
		Case When doc.Cd_Mda='01' Then 'S/.' Else 'US$.' End As NomMda,
		doc.CamMda, sum(doc.TotalS) As SaldoS,sum(doc.TotalD) As SaldoD
		,Max(isnull(doc.CA01,'')) as CA01
		,Max(isnull(doc.CA02,'')) as CA02
		,Max(isnull(doc.CA03,'')) as CA03
		,Max(isnull(doc.CA04,'')) as CA04
		,Max(isnull(doc.CA05,'')) as CA05
		,Max(isnull(doc.CA06,'')) as CA06
		,Max(isnull(doc.CA10,'')) as CA07
		,Max(isnull(doc.CA08,'')) as CA08
		,Max(isnull(doc.CA09,'')) as CA09
		,Max(isnull(doc.CA10,'')) as CA10
		,sum(doc.MtoD) as MtoD,sum(doc.MtoH) as MtoH
		,sum(doc.MtoD_ME) as MtoD_ME,sum(doc.MtoH_ME) as MtoH_ME
		,doc.FecCbr
		,doc.FecED
		,doc.FecMov
		,doc.FecVD
		,case when 
		ISNULL(Max(doc.FecVD),ISNULL(Max(doc.FecCbr),'')) ='' 
		then null else 
		--case when 1*-DATEDIFF(day,getdate(),ISNULL(Max(doc.FecVD),ISNULL(Max(doc.FecCbr),'')))<0 then null else 
		DATEDIFF(day,getdate(),ISNULL(Max(doc.FecVD),ISNULL(Max(doc.FecCbr),''))) end SaldoDias--CONVERT(nvarchar,@FecFin,103) antes estaba eso ahora esta getdate
		,case ISNULL(Max(doc.FecCbr),ISNULL(Max(doc.FecVD),'')) 
		when '' then '' 
		else case when DATEDIFF(day,getdate(),ISNULL(Max(doc.FecVD),ISNULL(Max(doc.FecCbr),''))) <= 0 then 'Venc.' end end as Est--CONVERT(nvarchar,@FecFin,103) antes estaba eso ahora esta getdate
		,@Cd_Mda as Cd_MdCons

		from
		(	
			Select d.* From 
			(
				  SELECT DISTINCT 
				  v.RucE, c.Ejer, '' AS Cd_Vta, CONVERT(varchar, v.Cd_Ltr) AS Cd_Ltr, c.RegCtb, c.Cd_Clt, 39 AS Cd_TD, '' AS NroSre, ISNULL(v.NroRenv, '') + v.NroLtr AS NroDoc, 
				  c.Cd_Mda, c.TipCam AS CamMda, 
				  CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END AS TotalS, 
				  CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END AS TotalD
				  ,v.CA01
				  ,v.CA02
				  ,v.CA03
				  ,v.CA04
				  ,v.CA05
				  ,v.CA06
				  ,v.CA07
				  ,v.CA08
				  ,v.CA09
				  ,v.CA10
				  ,CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * c.TipCam) ELSE v.Total END as MtoD
				  ,0.00 as MtoH
				  ,CASE WHEN isnull(c.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN c.TipCam = 0 THEN 0 ELSE CONVERT(decimal(13, 2), v.Total / c.TipCam) END END as MtoD_ME
				  ,0.00 as MtoH_ME
				  ,null as FecCbr
				  ,null as FecED
				  ,convert(nvarchar,v.FecGiro,103) as FecMov
				  ,convert(nvarchar,v.FecVenc,103) as FecVD
					FROM dbo.Letra_Cobro AS v LEFT JOIN
					dbo.Canje AS c ON c.RucE = v.RucE AND c.Cd_Cnj = v.Cd_Cnj
					where v.RucE = @RucE and c.IB_Anulado <> 1
			)as d Where d.RucE=@RucE and
		case when isnull(@Cd_Clt,'')<>'' then d.Cd_Clt else '' end = isnull(@cd_Clt,'') 
		
		
		Union
		
		select
		v.RucE,
		v.Ejer,
		'' as Cd_Vta,
		'' as Cd_Ltr,
		'' as RegCtb,
		v.Cd_Clt,
		v.Cd_TD,
		'' as NroSre,
		v.NroDoc,
		v.Cd_MdRg as Cd_Mda,
		max(case when isnull(v.IB_EsProv,0)=1 then v.CamMda else 0 end) as CamMda ,
		sum(v.MtoD-v.MtoH) as TotalS,
		sum(v.MtoD_ME-v.MtoH_ME) as TotalD,
		max(lc.CA01) as CA01,
		max(lc.CA02) as CA02,
		max(lc.CA03) as CA03,
		max(lc.CA04) as CA04,
		max(lc.CA05) as CA05,
		max(lc.CA06) as CA06,
		max(lc.CA07) as CA07,
		max(lc.CA08) as CA08,
		max(lc.CA09) as CA09,
		max(lc.CA10) as CA10,
		sum(v.MtoD) as Monto,
		sum(v.MtoH) as Cobrado,
		sum(v.MtoD_ME) as Monto_ME,
		sum(v.MtoH_ME) as Cobrado_ME,

		MAX(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecCbr,103) else '' end) as FecCbr,
		MAX(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecED,103) else '' end) as FecED,
		MAX(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecMov,103) else '' end) as FecMov,
		MAX(case when isnull(v.IB_EsProv,0)=1 then Convert(nvarchar,v.FecVD,103) else '' end) as FecVd
		from Voucher v
		inner join
		(
			Select 
			v.RucE,	
			--v.Ejer,	
			isnull(v.Cd_Clt,'') As Cd_Clt,
			isnull(v.Cd_TD,'') As Cd_TD,
			isnull(v.NroDoc,'') As NroDoc
			From Voucher v 
			Where  v.RucE=@RucE 
					--and v.Ejer=@Ejer 
					and isnull(v.IB_Anulado,0)<>1
					and v.Cd_TD = '39' 
					--and v.Cd_Clt = @Cd_Clt
					and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@cd_Clt,'') 
					and v.Prdo not in ('00','13','14')
			Group by v.RucE,/* v.Ejer,*/ isnull(v.Cd_Clt,''), isnull(v.Cd_TD,''), isnull(v.NroDoc,'')
			having sum(MtoD-MtoH) != 0 and sum(MtoD_ME-MtoH_ME)!= 0
		) as t on t.RucE = v.RucE /*and t.Ejer = v.Ejer*/ and t.Cd_Clt = v.Cd_Clt and t.Cd_TD = v.Cd_TD and t.NroDoc = v.NroDoc
		left join Letra_Cobro lc on lc.RucE =t.RucE and isnull(lc.NroRenv,'')+lc.NroLtr = t.NroDoc
		where v.RucE = @RucE and isnull(v.IB_Anulado,0)<>1--and v.NroDoc = '002405'
		group by 
		--v.Prdo,
		v.RucE,
		v.Ejer,
		v.Cd_Clt,
		v.Cd_TD,
		v.NroDoc,
		v.Cd_MdRg
		Having SUM(v.MtoD-MtoH)+SUM(v.MtoD_ME-v.MtoH_ME)!=0
			) as doc
			Inner Join TipDoc t On t.Cd_TD=doc.Cd_TD
			Where
				doc.Cd_Ltr not in 
				(
					Select c.Cd_Ltr From CanjeDet c Inner Join Canje e On e.RucE=c.RucE and e.Cd_Cnj=c.Cd_Cnj and isnull(e.IB_Anulado,0)=0 Where c.RucE=@RucE and isnull(c.Cd_Ltr,0)<>0
				)
				and doc.Cd_Ltr not in 
				(
					Select l.Cd_Ltr From Canje c Inner Join Letra_Cobro l On l.RucE=c.RucE and l.Cd_Cnj=c.Cd_Cnj Where c.RucE=@RucE and case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@cd_Clt,'') and isnull(c.IB_Anulado,0)=0
				)
			Group by doc.RegCtb,doc.Cd_Vta,doc.Cd_Clt,doc.Cd_Ltr,doc.Cd_TD,t.NCorto, doc.NroSre, doc.NroDoc, doc.Cd_Mda,doc.CamMda
				,doc.FecCbr
				,doc.FecED
				,doc.FecMov
				,doc.FecVD
			Having sum(doc.TotalS)+sum(doc.TotalD)<>0
		) as t
		where t.FecMov between @FecIni and @FecFin order by NroDoc
------Fin Letras-----------

--<JA: 11/03/2012> Creacion del SP
--exec Rpt_LtrCtasCorrientes3 '20513272848','2012','01','01/10/2011','30/12/2012','CLT0000777'

--select * from Cliente2 where RucE = '20513272848' and Cd_TDI = '06' order by RSocial,ApPat




GO

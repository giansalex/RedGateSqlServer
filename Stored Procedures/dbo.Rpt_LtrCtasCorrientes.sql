SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_LtrCtasCorrientes]
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
	select v.Cd_Clt,v.RucE from Voucher v
	left join
	(
		select RegCtb,Cd_TD,NroSre,NroDoc from Voucher where RucE = @RucE and Ejer = @Ejer and isnull(Cd_Clt,'')<>''
		group by RegCtb,Cd_TD,NroSre,NroDoc
		having sum(MtoD)-sum(MtoH)<>0
	) as t on t.RegCtb = v.regCtb and t.Cd_TD = v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc = v.NroDoc
	where v.RucE = @RucE and v.Ejer = @Ejer and isnull(Cd_Clt,'')<>''
	group by v.rucE,v.RegCtb,v.Cd_Clt,v.Cd_TD,v.NroSre,v.NroDoc 
	having sum(v.MtoD)-sum(v.MtoH)<>0

union all

	select v.CD_Clt,v.RucE from Voucher v
	left join
	(
		select RegCtb,Cd_TD,NroSre,NroDoc from Voucher where RucE = @RucE and Ejer = @Ejer and isnull(Cd_Clt,'')<>'' and isnull(Cd_TD,'')='39'
		group by RegCtb,Cd_TD,NroSre,NroDoc
		having sum(MtoD)-sum(MtoH)<>0
	) as t on t.RegCtb = v.regCtb and t.Cd_TD = v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc = v.NroDoc
	where v.RucE = @RucE and v.Ejer = @Ejer and isnull(Cd_Clt,'')<>'' and isnull(v.Cd_TD,'')='39'
	group by v.rucE,v.RegCtb,v.Cd_Clt,v.Cd_TD,v.NroSre,v.NroDoc 
	having sum(v.MtoD)-sum(v.MtoH)<>0
) as c 
Left join Cliente2 clt on c.Cd_Clt = clt.Cd_Clt and c.RucE = clt.RucE
where case when isnull(@Cd_Clt,'')<>'' then c.Cd_Clt else '' end = isnull(@Cd_Clt,'')
group by c.Cd_clt,c.rucE, case when isnull(clt.Rsocial,'')='' then clt.ApPat + ' ' + clt.ApMat +' '+clt.Nom else clt.RSocial end ,clt.Direc
,clt.NDoc
order by Cliente
----Fin Cliente--------

---Documentos-----------

select v.RegCtb,v.Cd_Clt,v.Cd_TD,td.NCorto,v.NroSre,v.NroDoc
,isnull(v.Cd_MdRg,'') as Cd_MdRg
,v.FecCbr
,v.FecMov
,v.FecED
,v.CamMda
,sum(v.MtoD) as MtoD,sum(v.MtoH) as MtoH, sum(v.MtoD-v.MtoH) as Saldo
,sum(v.MtoD_ME) as MtoD_ME,sum(v.MtoH_ME) as MtoH_ME, sum(v.MtoD_ME-v.MtoH_ME) as Saldo_ME 
from Voucher v
left join
(
	select RegCtb,Cd_TD,NroSre,NroDoc from Voucher where RucE = @RucE and Ejer = @Ejer and isnull(Cd_Clt,'')<>''
	group by RegCtb,Cd_TD,NroSre,NroDoc
	having sum(MtoD)-sum(MtoH)<>0
) as t on t.RegCtb = v.regCtb and t.Cd_TD = v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc = v.NroDoc
inner join TipDoc td on td.Cd_TD = v.Cd_TD 
where v.RucE = @RucE 
--and v.Ejer = @Ejer 
and isnull(Cd_Clt,'')<>'' and v.Cd_TD <>'39'
and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@Cd_Clt,'')
group by v.RegCtb,v.Cd_Clt,v.Cd_TD,td.NCorto,v.NroSre,v.NroDoc,isnull(v.Cd_MdRg,'')
,v.FecCbr
,v.FecMov
,v.FecED
,v.CamMda
having sum(v.MtoD)-sum(v.MtoH)<>0
------Fin Documentos------


------Letras--------------
select v.RegCtb,v.Cd_Clt,v.Cd_TD,td.NCorto,v.NroSre,isnull(t1.NroRenv,'')+v.NroDoc as NroDoc
,isnull(v.Cd_MdRg,'') as Cd_MdRg
,v.FecCbr
,v.FecMov
,v.FecED
,v.CamMda
,t1.CA01
,t1.CA02
,t1.CA03
,t1.CA04
,t1.CA05
,t1.CA06
,t1.CA07
,t1.CA08
,t1.CA09
,t1.CA10
,sum(v.MtoD) as MtoD,sum(v.MtoH) as MtoH, sum(v.MtoD-v.MtoH) as Saldo
,sum(v.MtoD_ME) as MtoD_ME,sum(v.MtoH_ME) as MtoH_ME, sum(v.MtoD_ME-v.MtoH_ME) as Saldo_ME from Voucher v
left join
(
	select RegCtb,Cd_TD,NroSre,NroDoc from Voucher where RucE = @RucE and Ejer = @Ejer and isnull(Cd_Clt,'')<>'' and isnull(Cd_TD,'')='39'
	group by RegCtb,Cd_TD,NroSre,NroDoc
	having sum(MtoD)-sum(MtoH)<>0
) as t on t.RegCtb = v.regCtb and t.Cd_TD = v.Cd_TD and t.NroSre=v.NroSre and t.NroDoc = v.NroDoc
inner join
(
	select cd.Ejer,cd.RegCtb,lc.* from Letra_Cobro lc 
	left join  CanjeDetRM cd  on lc.RucE = cd.RucE and lc.Cd_Cnj = cd.Cd_Cnj
	left join Letra_CobroRM lcr on lcr.RucE = cd.RucE and lcr.Cd_Cnj = lc.Cd_Cnj and lcr.Cd_Ltr = cd.Cd_Ltr
	where cd.RucE = @RucE and isnull(cd.IB_Anulado,0)=0
) as t1 on t1.RucE = v.RucE and t1.RegCtb = v.RegCtb and t1.Ejer=v.Ejer and t1.Cd_TD = v.Cd_TD and v.NroDoc = t1.NroLtr
inner join TipDoc td on td.Cd_Td = v.Cd_TD
where v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.Cd_Clt,'')<>'' and isnull(v.Cd_TD,'')='39'
and case when isnull(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = isnull(@Cd_Clt,'')
group by 
v.RegCtb,v.Cd_Clt,v.Cd_TD,td.NCorto,v.NroSre,
--v.NroDoc
isnull(t1.NroRenv,'')+v.NroDoc
,isnull(v.Cd_MdRg,'')
,v.FecCbr
,v.FecMov
,v.FecED
,v.CamMda
,t1.CA01
,t1.CA02
,t1.CA03
,t1.CA04
,t1.CA05
,t1.CA06
,t1.CA07
,t1.CA08
,t1.CA09
,t1.CA10
having sum(v.MtoD)-sum(v.MtoH)<>0
------Fin Letras-----------

--<JA: 11/03/2012> Creacion del SP
--exec Rpt_LtrCtasCorrientes '11111111111','2012','01','01/01/2012','29/03/2012',''
GO

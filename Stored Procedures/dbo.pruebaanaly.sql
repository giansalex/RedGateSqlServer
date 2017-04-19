SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec pruebaanaly '111111111111','2012','01/01/2012','31/03/2012'

create procedure [dbo].[pruebaanaly]
@RucE NVarchar (11),
@eje NVarchar (4),
@Fec_inicio datetime,
@fec_fin    datetime
as
--set @RucE='111111111111'
--set @eje='2012'
--set @Fec_inicio='01/01/2012'
--set @Fec_fin='31/03/2012'





--cliente2
----select *from venta
--nro documento,NroDoc
--serie, NroSre
--RuCe
--Eje
--FecMov
--RSocial
--Nom
--ApPat
--ApMat

select  v.Cd_Clt,clt.NDoc, case when isnull(Clt.RSocial,'')='' then  isnull(Clt.Nom,'')+' '+
isnull(Clt.ApPat,'')+' '+isnull (Clt.ApMat,'') else isnull(Clt.RSocial,'') end as Nombre,
v.Cd_Td, v.NroSre, v.NroDoc,sum(v.Total)as Total from venta v 
inner join cliente2 clt on v.RucE=clt.RuCe and v.Cd_Clt=clt.Cd_Clt
where  v.RucE=@RucE and v.eje=@eje and v.FecMov between @Fec_inicio and @Fec_fin 
group by Cd_Td, v.Cd_Clt, v.NroSre, v.NroDoc,Clt.RSocial, Clt.Nom, Clt.ApPat, Clt.ApMat,clt.NDoc

order by v.Cd_Clt
--



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Com_ObtnMtoDetrac_Cons '11111111111',null,'PD00005',null
CREATE procedure [dbo].[Com_ObtnMtoDetrac_Cons]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Prod char(7),
@Cd_Srv char(7)
As

--set @RucE='11111111111'
--set @Cd_Prv='PRV0247'
--set @Cd_Prod='PD00004'



select * from(
select t1.RucE, t1.Cod, t1.Porc, t1.MtoDtr from ( select cd.RuCE, cd.Cd_CDtr,cdh.FecVig,isnull(cd.Cd_Prod, cd.Cd_Srv) Cod, cdh.Porc, cdh.MtoDtr
from ConceptosDetrac cd 
	inner join ConceptoDetracHist cdh on cd.RucE=cdh.RucE and cd.Cd_CDtr=cdh.Cd_CDtr
where cd.RucE=@RucE
	and Case when isnull(@Cd_Prod,'')<>'' then cd.Cd_Prod else '' end = isnull(@Cd_Prod,'') 
	and Case when isnull(@Cd_Srv,'')<>'' then cd.Cd_Srv else '' end = isnull(@Cd_Srv,'')
	) as t1 left join (	
----obteniendo el maximo del producto o servicio
select Max(cd.RucE) RucE/*, cp.Cd_Prv*/, cd.Cd_CDtr, cd.Descrip, isnull(cd.Cd_Prod, cd.Cd_Srv) Cod, Max(cdh.FecVig) FecVig
from ConceptosDetrac cd inner join ConceptoDetracHist cdh on cd.RucE=cdh.RucE and cd.Cd_CDtr=cdh.Cd_CDtr
where 
	cd.RucE=@RucE 
	and Case when isnull(@Cd_Prod,'')<>'' then cd.Cd_Prod else '' end = isnull(@Cd_Prod,'') 
	and Case when isnull(@Cd_Srv,'')<>'' then cd.Cd_Srv else '' end = isnull(@Cd_Srv,'')
group by cd.Cd_CDtr, cd.Descrip, isnull(cd.Cd_Prod, cd.Cd_Srv)
) as t2 on t2.RucE=t1.RucE and t2.Cd_CDtr=t1.Cd_CDtr and t2.Cod=t1.Cod and t2.FecVig=t1.FecVig
) as t3 group by RucE,Cod,Porc,MtoDtr


print @RucE
PRINT @Cd_Prv
PRINT @Cd_Prod
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [user321].[DetraccionConcept]
as
select cd.RucE, cd.Cd_CDtr, cd.Descrip, case(isnull(cd.Cd_Prod,'')) when '' then cd.Cd_Srv else cd.Cd_Prod end as Cd_ProdServ, case(isnull(cd.Cd_Prod,'')) when '' then s2.Nombre else p2.Nombre1 end as ProdServ, max(ch.fecvig) as FecVig from ConceptosDetrac cd 
left join ConceptoDetracHist ch on cd.RucE=ch.RucE and cd.Cd_CDtr=ch.Cd_CDtr left join producto2 p2 on p2.RucE=cd.RucE and p2.Cd_Prod=cd.Cd_Prod left join servicio2 s2 on s2.RucE=cd.RucE and 
s2.Cd_Srv=cd.Cd_Srv group by cd.RucE,cd.Cd_CDtr,cd.Descrip,cd.Cd_Prod, cd.Cd_Srv,p2.Nombre1,s2.Nombre
--Leyenda --
--JJ 07/02/2011 :<Creacion de la vista>
GO

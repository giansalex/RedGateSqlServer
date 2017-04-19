SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [user321].[DetraccionHistorico]
as
select cd.RucE, cd.Cd_CDtr,cd.FecVig,cd.Porc,
cd.MtoDtr as MtoDtr from ConceptoDetracHist cd
-- Leyenda --
--JJ 07/02/2011 : <Creacion del la vista>
GO

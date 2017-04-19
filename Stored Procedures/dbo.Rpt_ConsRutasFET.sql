SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ConsRutasFET] @RucE nvarchar(11)
as 
select distinct isnull(CA01,'--') as Ruta from Cliente2 where RucE = @RucE

--Creado : JA <25/025/2012>
--Temporal, facil y se borra.
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptoDetracUltCod]
@RucE nvarchar(11),
@Cd_CDtr char(4) output
as

set @Cd_CDtr=(select user321.Cd_CDtr(@RucE))
select @Cd_CDtr
-- Leyenda --
--JJ 04/02/2011 :<Creacion del Procedimiento almacenado>
GO

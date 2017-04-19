SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Ctb_ConceptosDetracConsUn]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@msj varchar(100) output
as

if not exists (select Top 1 *from ConceptosDetrac where RucE=@RucE and Cd_CDtr=@Cd_CDtr)
		set @msj='Concepto de Detraccion no existe'
else
	begin
		select Top 1 *from ConceptosDetrac where RucE=@RucE and Cd_CDtr=@Cd_CDtr
	end
-- Leyenda --
-- JJ 05/02/2011: <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptoDetracHistMdf]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@FecVig smalldatetime,
@Porc decimal(6,3),
@MtoDtr decimal(13,2),
@msj varchar(100) output
as
if not exists(select top 1 *from ConceptoDetracHist where FecVig=@FecVig and RucE=@RucE and Cd_CDtr=@Cd_CDtr)
	set @msj='No existe concepto detraccion para la fecha ' + Convert(nvarchar,@FecVig,103)
else
	begin
		update ConceptoDetracHist set Porc=@Porc, MtoDtr=@MtoDtr where FecVig=@FecVig and RucE=@RucE
		and Cd_CDtr=@Cd_CDtr
	end
-- Leyenda --
--JJ 04/01/2011 :: <Creacion del procedimiento almacenado>


GO

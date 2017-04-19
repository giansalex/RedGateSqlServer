SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptosDetracCrea]
@RucE nvarchar(11),
@Cd_CDtr char(4) output,
@Descrip varchar(200),
@Cd_Prod char(7),
@Cd_Srv char(7),
@msj varchar(100) output
as
if exists (select top 1 * from ConceptosDetrac where RucE=@RucE and  Descrip=@Descrip )
		set @msj='Concepto detraccion ya existe'
else 
	begin
		set @Cd_CDtr=user321.Cd_CDtr(@RucE)
		insert into ConceptosDetrac(RucE,Cd_CDtr,Descrip,Cd_Prod,Cd_Srv)
		values(@RucE,@Cd_CDtr,@Descrip,@Cd_Prod,@Cd_Srv)
	end

-- Leyenda --
--JJ 05/02/2011 :<Creacion del procedimiento almacenado>


GO

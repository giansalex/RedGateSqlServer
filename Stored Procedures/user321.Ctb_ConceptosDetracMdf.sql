SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptosDetracMdf]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@Cd_Prod char(7),
@Cd_Srv char(7),
@Descrip varchar(200),
@msj varchar(100) output
as
if not exists (select top 1 *from ConceptosDetrac where Cd_CDtr=@Cd_CDtr and RucE=@RucE)
		set @msj='Concepto detraccion no existe'
else
	begin
		update ConceptosDetrac set Descrip=@Descrip,Cd_Prod=@Cd_Prod, Cd_Srv=@Cd_Srv
		where RucE=@RucE and Cd_CDtr=@Cd_CDtr
	end
GO

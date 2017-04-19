SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Gfm_TipMantConsUn](
	@Cd_TM char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
as
if not exists(select * from TipMant where Cd_TM = @Cd_TM and RucE = @RucE)
	set @msj = 'Tipo de mantenimineto no existe'+@Cd_TM
else
	select * from TipMant where Cd_TM = @Cd_TM and RucE = @RucE
print @msj
--Leyenda
--JV : 19/07/2011 : <Creación de procedimiento almacenado.>
GO

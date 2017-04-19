SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieElim]
@RucE nvarchar(11),
@Cd_Sr nvarchar(4),
@msj varchar(100) output
as 
if not exists (select * from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr)
	set @msj = 'Serie no existe'
else
begin transaction
	if exists (select * from Numeracion where RucE=@RucE and Cd_Sr=@Cd_Sr)
	begin
		set @msj = 'Serie no puede ser eliminado, por estar enlazada a informacion de Numeracion'
		rollback transaction
		return
	end

	delete from SeriesXArea where RucE=@RucE and Cd_Sr=@Cd_Sr
	delete from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr

	if @@rowcount <= 0
	begin
		 set @msj = 'Serie no pudo ser eliminado'
		rollback transaction
		return
	end
commit transaction
print @msj
GO

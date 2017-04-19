SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[GenerarNroFab]
@RucE nvarchar(11),
@NroFab varchar(50) output,
@msj varchar(100) output
as
      declare @c varchar(10), @n int
      select @c = count(NroFab) from FabFabricacion where RucE=@RucE
      if @c=0
	set @c='FAB0000001'
      else
	begin
	select @c=max(NroFab) from FabFabricacion where RucE=@RucE
	set @c = right(@c,7)
	set @n = convert(int, @c)+1
	set @c = 'FAB'+right('0000000'+ltrim(str(@n)), 7)
	end
	set @NroFab = @c
print @NroFab
-- Leyenda --
-- CE : 2013-01-11 : <Creacion del procedimiento almacenado>
GO

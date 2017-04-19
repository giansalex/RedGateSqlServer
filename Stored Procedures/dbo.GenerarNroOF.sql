SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GenerarNroOF]
@RucE nvarchar(11),
@NroOF varchar(50) output,
@msj varchar(100) output
as
      declare @c varchar(10), @n int
      select @c = count(NroOF) from OrdFabricacion where RucE=@RucE
      if @c=0
	set @c='OF00000001'
      else
	begin
	select @c=max(NroOF) from OrdFabricacion where RucE=@RucE
	set @c = right(@c,8)
	set @n = convert(int, @c)+1
	set @c = 'OF'+right('00000000'+ltrim(str(@n)), 8)
	end
	set @NroOF = @c
print @NroOF
-- Leyenda --
-- FL : 2011-03-10 : <Creacion del procedimiento almacenado>
GO

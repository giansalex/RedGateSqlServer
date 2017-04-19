SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CategElim]
@Cd_Cat nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Categoria where Cd_Cat=@Cd_Cat)
	set @msj = 'Categoria no existe'
else
begin
	delete from Categoria where Cd_Cat=@Cd_Cat

	if @@rowcount <= 0
	set @msj = 'Categoria no pudo ser eliminado'	
end
GO

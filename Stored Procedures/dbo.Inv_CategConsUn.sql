SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CategConsUn]
@Cd_Cat nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Categoria where Cd_Cat=@Cd_Cat)
	set @msj = 'Categoria no existe'
else	select * from Categoria where Cd_Cat=@Cd_Cat
GO

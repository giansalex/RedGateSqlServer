SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_AlertXUsuElim]
@NomUsu varchar(10),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	
	If exists (Select Top 1 NomUsu From AlertXUsu Where NomUsu=@NomUsu)
		Begin
			Delete From AlertXUsu
			Where NomUsu = @NomUsu
		End
END
GO

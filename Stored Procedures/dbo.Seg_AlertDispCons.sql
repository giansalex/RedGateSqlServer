SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_AlertDispCons]
@RucE char(11),
@NomUsu varchar(10),
@msj varchar(100) output
AS
BEGIN

	SET NOCOUNT ON;
	If Not Exists (Select Top 1 * From TipAlert)
		Set @msj = 'No existen alertas'
	Else
		Begin
			Select Cd_TA, Descrip
			From TipAlert
			Where Cd_TA not in (Select Cd_TA
	 							From AlertXUsu
								where RucE=@RucE and NomUsu = @NomUsu)
		End
END
GO

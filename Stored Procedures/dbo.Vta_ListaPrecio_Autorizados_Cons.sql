SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Autorizados_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10),
    @NomUsu NVARCHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_LP], [NomUsu], [Estado], [FechaAsignacion] 
	FROM   [dbo].[ListaPrecio_Autorizados] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 
	       AND ([NomUsu] = @NomUsu OR @NomUsu IS NULL) 

	COMMIT

GO

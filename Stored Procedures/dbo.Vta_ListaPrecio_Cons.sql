SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_LP], [Nombre], [Descripcion], [Estado], [RequiereAutorizacion], [TieneFechaVigencia], [PermiteModificacionPreciosVta] 
	FROM   [dbo].[ListaPrecio] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 

	COMMIT

GO

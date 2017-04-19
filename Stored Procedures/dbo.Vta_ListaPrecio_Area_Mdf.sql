SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Area_Mdf] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Area nvarchar(6),
    @Estado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ListaPrecio_Area]
	SET    [RucE] = @RucE, [Cd_LP] = @Cd_LP, [Cd_Area] = @Cd_Area, [Estado] = @Estado
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Area] = @Cd_Area
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Cd_Area], [Estado]
	FROM   [dbo].[ListaPrecio_Area]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Area] = @Cd_Area	
	-- End Return Select <- do not remove

	COMMIT

GO

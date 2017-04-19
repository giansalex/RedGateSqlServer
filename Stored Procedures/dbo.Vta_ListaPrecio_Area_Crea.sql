SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Area_Crea] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Area nvarchar(6),
    @Estado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ListaPrecio_Area] ([RucE], [Cd_LP], [Cd_Area], [Estado])
	SELECT @RucE, @Cd_LP, @Cd_Area, @Estado
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Cd_Area], [Estado]
	FROM   [dbo].[ListaPrecio_Area]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Area] = @Cd_Area
	-- End Return Select <- do not remove
               
	COMMIT

GO

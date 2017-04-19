SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Area_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10),
    @Cd_Area NVARCHAR(6)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_LP], [Cd_Area], [Estado] 
	FROM   [dbo].[ListaPrecio_Area] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 
	       AND ([Cd_Area] = @Cd_Area OR @Cd_Area IS NULL) 

	COMMIT

GO

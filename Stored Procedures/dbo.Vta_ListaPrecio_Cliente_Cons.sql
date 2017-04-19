SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Cliente_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10),
    @Cd_Clt CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_LP], [Cd_Clt], [Estado] 
	FROM   [dbo].[ListaPrecio_Cliente] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 
	       AND ([Cd_Clt] = @Cd_Clt OR @Cd_Clt IS NULL) 

	COMMIT

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ContactoxDocumento_Elim] 
    @Id_ContactoxDoc int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ContactoxDocumento]
	WHERE  [Id_ContactoxDoc] = @Id_ContactoxDoc

	COMMIT

GO

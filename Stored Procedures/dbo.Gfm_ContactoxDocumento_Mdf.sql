SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ContactoxDocumento_Mdf] 
    @Id_ContactoxDoc int,
    @RucE nvarchar(11),
    @Cd_TDES char(2),
    @Codigo nvarchar(10),
    @Id_Gen int,
    @CorreoEnviado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ContactoxDocumento]
	SET    [RucE] = @RucE, [Cd_TDES] = @Cd_TDES, [Codigo] = @Codigo, [Id_Gen] = @Id_Gen, [CorreoEnviado] = @CorreoEnviado
	WHERE  [Id_ContactoxDoc] = @Id_ContactoxDoc
	
	-- Begin Return Select <- do not remove
	SELECT [Id_ContactoxDoc], [RucE], [Cd_TDES], [Codigo], [Id_Gen], [CorreoEnviado]
	FROM   [dbo].[ContactoxDocumento]
	WHERE  [Id_ContactoxDoc] = @Id_ContactoxDoc	
	-- End Return Select <- do not remove

	COMMIT

GO

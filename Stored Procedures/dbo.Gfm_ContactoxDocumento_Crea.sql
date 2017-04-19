SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ContactoxDocumento_Crea] 
	@Id_ContactoxDoc int out,
    @RucE nvarchar(11),
    @Cd_TDES char(2),
    @Codigo nvarchar(10),
    @Id_Gen int,
    @CorreoEnviado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	set @Id_ContactoxDoc = 0
	INSERT INTO [dbo].[ContactoxDocumento] ([RucE], [Cd_TDES], [Codigo], [Id_Gen], [CorreoEnviado])
	SELECT @RucE, @Cd_TDES, @Codigo, @Id_Gen, @CorreoEnviado
	
	-- Begin Return Select <- do not remove
	set @Id_ContactoxDoc = SCOPE_IDENTITY()
	--SELECT [Id_ContactoxDoc], [RucE], [Cd_TDES], [Codigo], [Id_Gen], [CorreoEnviado]
	--FROM   [dbo].[ContactoxDocumento]
	--WHERE  [Id_ContactoxDoc] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ContactoxDocumento_Cons] 
    @Id_ContactoxDoc INT,
    @RucE nvarchar(11),
    @Cd_TDES char(2),
    @Codigo nvarchar(10),
    @Id_Gen int,
    @CorreoEnviado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Id_ContactoxDoc], [RucE], [Cd_TDES], [Codigo], [Id_Gen], [CorreoEnviado] 
	FROM   [dbo].[ContactoxDocumento] 
	WHERE  
			([Id_ContactoxDoc] = @Id_ContactoxDoc OR @Id_ContactoxDoc IS NULL)
	And		(RucE = @RucE or @RucE is null)
	And		(Cd_TDES = @Cd_TDES or @Cd_TDES is null)
	And		(Codigo = @Codigo or @Codigo is null)
	And		(Id_Gen = @Id_Gen or @Id_Gen is null)
	And		(CorreoEnviado = @CorreoEnviado or @CorreoEnviado is null)

	COMMIT
GO

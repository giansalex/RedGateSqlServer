SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Autorizados_Crea] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @NomUsu nvarchar(10),
    @Estado bit,
    @FechaAsignacion date
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ListaPrecio_Autorizados] ([RucE], [Cd_LP], [NomUsu], [Estado], [FechaAsignacion])
	SELECT @RucE, @Cd_LP, @NomUsu, @Estado, @FechaAsignacion
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [NomUsu], [Estado], [FechaAsignacion]
	FROM   [dbo].[ListaPrecio_Autorizados]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [NomUsu] = @NomUsu
	-- End Return Select <- do not remove
               
	COMMIT

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Autorizados_Mdf] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @NomUsu nvarchar(10),
    @Estado bit,
    @FechaAsignacion date
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ListaPrecio_Autorizados]
	SET    [RucE] = @RucE, [Cd_LP] = @Cd_LP, [NomUsu] = @NomUsu, [Estado] = @Estado, [FechaAsignacion] = @FechaAsignacion
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [NomUsu] = @NomUsu
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [NomUsu], [Estado], [FechaAsignacion]
	FROM   [dbo].[ListaPrecio_Autorizados]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [NomUsu] = @NomUsu	
	-- End Return Select <- do not remove

	COMMIT

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Crea] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Nombre nvarchar(50),
    @Descripcion nvarchar(150),
    @Estado bit,
    @RequiereAutorizacion bit,
    @TieneFechaVigencia bit,
    @PermiteModificacionPreciosVta bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	Set @Cd_LP = dbo.Cd_LP(@RucE)
	INSERT INTO [dbo].[ListaPrecio] ([RucE], [Cd_LP], [Nombre], [Descripcion], [Estado], [RequiereAutorizacion], [TieneFechaVigencia], [PermiteModificacionPreciosVta])
	SELECT @RucE, @Cd_LP, @Nombre, @Descripcion, @Estado, @RequiereAutorizacion, @TieneFechaVigencia, @PermiteModificacionPreciosVta
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Nombre], [Descripcion], [Estado], [RequiereAutorizacion], [TieneFechaVigencia], [PermiteModificacionPreciosVta]
	FROM   [dbo].[ListaPrecio]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	-- End Return Select <- do not remove
               
	COMMIT

GO

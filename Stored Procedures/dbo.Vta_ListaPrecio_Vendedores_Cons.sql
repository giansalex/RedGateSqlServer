SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Vendedores_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10),
    @Cd_Vdr CHAR(7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF @Cd_LP IS NULL

	

	  SELECT [ListaPrecio_Vendedores].[RucE],[ListaPrecio].[Nombre] ,  [ListaPrecio_Vendedores].[Cd_LP], [Cd_Vdr],[ListaPrecio_Vendedores].[Estado] 
	  FROM   [dbo].[ListaPrecio_Vendedores] 
	  INNER JOIN [ListaPrecio]  ON [ListaPrecio].Cd_LP= [ListaPrecio_Vendedores].Cd_LP
	  WHERE  ([ListaPrecio_Vendedores].[RucE] = @RucE OR @RucE IS NULL) 	      
	       AND ([ListaPrecio_Vendedores].[Cd_Vdr] = @Cd_Vdr OR @Cd_Vdr IS NULL) 
		 
	

	ELSE
	BEGIN
	BEGIN TRAN	
	SELECT [RucE], [Cd_LP], [Cd_Vdr], [Estado] 
	FROM   [dbo].[ListaPrecio_Vendedores] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 
	       AND ([Cd_Vdr] = @Cd_Vdr OR @Cd_Vdr IS NULL) 
	
	
	COMMIT

	END
GO

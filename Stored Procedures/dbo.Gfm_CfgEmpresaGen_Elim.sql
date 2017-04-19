SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_CfgEmpresaGen_Elim] 
    @RucE nvarchar(11)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[CfgEmpresaGen]
	WHERE  [RucE] = @RucE

	COMMIT

GO

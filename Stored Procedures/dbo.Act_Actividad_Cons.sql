SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_Actividad_Cons] 
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Cd_Act], [Ruc], [Nom], [Descrip], [DescripInc], [FecInc], [FecInicio], [HrsEstm], [HrsReales], [FecFin], [Prdad1L2L], [Prdad4L], [PorcAvzdo], [Predec], [Cd_TrabRsp], [Cd_TrabEnc], [Cd_TA], [Cd_EA], [FecReg], [UsuCrea], [FecMdf], [UsuMdf] 
	FROM   [dbo].[Actividad]

	COMMIT

GO

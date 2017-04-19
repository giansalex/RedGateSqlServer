SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_ConexionesReporte_Elim]
	@RucE nvarchar(11)
As
	Delete From ReporteConexion Where RucE = @RucE
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Gfm_ConexionesReporte_Mdf]
	@RucE nvarchar(11),
	@CadenaConexion nvarchar(300),
	@Estado bit,
	@NombreConexion nvarchar(80)
As
Update ReporteConexion
Set CadenaConexion = @CadenaConexion,
	Estado = @Estado,
	NombreConexion = @NombreConexion
Where
	RucE = @RucE
GO

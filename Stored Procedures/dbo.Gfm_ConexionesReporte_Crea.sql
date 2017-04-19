SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Gfm_ConexionesReporte_Crea]
@RucE nvarchar(11),
@CadenaConexion nvarchar(300),
@Estado bit,
@NombreConexion nvarchar(80)
As
Insert Into ReporteConexion Values(@RucE,@CadenaConexion,@Estado,@NombreConexion)
GO

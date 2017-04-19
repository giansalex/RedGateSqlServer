SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_ConexionesReporte_ConsUn]
@rucE nvarchar(11)
As
Select RucE,CadenaConexion,Estado
From ReporteConexion
Where RucE = @rucE
GO

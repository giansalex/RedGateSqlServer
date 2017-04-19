SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConexionesReporte_Cons]
As
SELECT 
		RucE,
		CadenaConexion,
        NombreConexion,
		Estado 
From 
		ReporteConexion


--exec [dbo].[Gfm_ConexionesReporte_Cons]
GO

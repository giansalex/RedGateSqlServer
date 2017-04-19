SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE View [dbo].[View_ParametrosXReporte] As
SELECT     Reportes.RucE, TareaProgramada.TareaProgramadaID, Reportes.ReporteID, CASE substring(ReporteParametros.NombreParametro, 0, 1) 
                      WHEN '@' THEN ReporteParametros.NombreParametro ELSE '@' + ReporteParametros.NombreParametro END AS NombreParametro,ReporteConexion.CadenaConexion, Reportes.NombreConsulta, 
                      ReporteParametros.TipoParametro, TareaProgramadaParametro.ValorParametro
FROM         ReporteParametros INNER JOIN
                      TareaProgramada ON ReporteParametros.RucE = TareaProgramada.RucE INNER JOIN
                      TareaProgramadaParametro ON ReporteParametros.RucE = TareaProgramadaParametro.RucE AND 
                      ReporteParametros.ReporteID = TareaProgramadaParametro.ReporteID AND 
                      ReporteParametros.ReporteParametroID = TareaProgramadaParametro.ReporteParametroID AND TareaProgramada.RucE = TareaProgramadaParametro.RucE AND 
                      TareaProgramada.TareaProgramadaID = TareaProgramadaParametro.TareaProgramadaID INNER JOIN
                      Reportes ON ReporteParametros.ReporteID = Reportes.ReporteID AND ReporteParametros.RucE = Reportes.RucE INNER JOIN
                      ReporteConexion ON TareaProgramada.RucE = ReporteConexion.RucE AND Reportes.RucE = ReporteConexion.RucE
GO

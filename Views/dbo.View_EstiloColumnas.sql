SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[View_EstiloColumnas] aS
SELECT     
			TareaProgramada.RucE, 
			TareaProgramada.TareaProgramadaID, 
			ColumnasReporte.ReporteID, 
			ColumnasReporte.NombreColumna, 
			'style = "background:' + ColumnasReporte.ColorColumna + '; color:'+ColumnasReporte.ColorLetraColumna+';'+case(ColumnasReporte.EnNegrita) when 1 then 'font-weight:bold;' else '' end + case(ColumnasReporte.Derecha) when 1 then 'text-align:right;' else 'text-align:left;' end + '"' As Estilo,
			ColumnasReporte.TextoColumna
FROM        
			ColumnasReporte 
INNER JOIN
			Reportes 
ON 
			ColumnasReporte.ReporteID = Reportes.ReporteID AND 
			ColumnasReporte.RucE = Reportes.RucE 
INNER JOIN
			TareaProgramada 
ON 
			ColumnasReporte.RucE = TareaProgramada.RucE
GO

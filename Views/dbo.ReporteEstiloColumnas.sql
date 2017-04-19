SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View [dbo].[ReporteEstiloColumnas] As
	Select RucE,ReporteID,ColumnaReporteID,NombreColumna, 'style="background:'+ColorColumna +';color:'+ColorLetraColumna+';'+case(EnNegrita) when 1 then 'font-weight:bold;' when 0 then '' end + case(Derecha) when 1 then 'text-align:right;' when 0 then 'text-align:left;'end +'"' As Estilo From ColumnasReporte
GO

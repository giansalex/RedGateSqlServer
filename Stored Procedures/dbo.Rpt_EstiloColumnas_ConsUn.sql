SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Rpt_EstiloColumnas_ConsUn] 
	@rucE nvarchar(11),
	@reporteID char(10)
As
SELECT 
		RucE,
		ReporteID,
		ColumnaReporteID,
		NombreColumna,
		Estilo 
FROM 
		ReporteEstiloColumnas
WHERE
		RucE = @rucE And
		ReporteID = @reporteID
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_TipoReporteCons]

@msj varchar(100) output

AS

SELECT 
	*
FROM 
	TipoReporte

-- Leyenda --
-- DI : 06/08/2012 <Creacion del SP>

GO

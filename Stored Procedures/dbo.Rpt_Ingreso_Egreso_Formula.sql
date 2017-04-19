SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_Ingreso_Egreso_Formula]

@RucE nvarchar(11),
@Ejer nvarchar(4),

@msj varchar(100) output

AS

	SELECT '0' As Posi, '0' As Nivel, 'I' AS Codigo, 'INGRESO' As Descrip
	UNION ALL SELECT '2' As Posi, '5' As Nivel, 'I' AS Codigo, 'TOTAL INGRESO' As Descrip
	UNION ALL SELECT '3' As Posi, '0' As Nivel, 'E' AS Codigo, 'EGRESO' As Descrip
	UNION ALL SELECT '5' As Posi, '5' As Nivel, 'E' AS Codigo, 'TOTAL EGRESO' As Descrip
	
-- Leyenda --
-- DI : 20/10/2011 <Creacion del procedimiento almacenado>

GO

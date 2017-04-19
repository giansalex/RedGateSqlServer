SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_RubrosReporteCons_TR]

@RucE nvarchar(11),
@Cd_TR nvarchar(2),
@msj varchar(100) output

AS

SELECT 
	Nivel,
	Cd_Rb,
	Descrip,
	isnull(Simbolo,'') As Simbolo,
	isnull(Formula,'') As Formula,
	Estado
FROM 
	RubrosReporte
WHERE
	RucE=@RucE
	and Cd_TR=@Cd_TR
Order by Nivel

-- Leyenda --
-- DI : 06/08/2012 <Creacion del SP>

GO

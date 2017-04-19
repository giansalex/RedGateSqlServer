SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Estructura_RF]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TR nvarchar(2),
@msj varchar(100) output

AS

	Select 
		Nivel,
		Cd_Rb,
		Descrip, 
		isnull(Simbolo,'') As Simbolo,
		isnull(Formula,'') As Formula 
	From 
		RubrosReporte 
	Where 
		RucE=@RucE
		and Cd_TR=@Cd_TR 
		and Estado=1
		--and Nivel < 6 --> Temporal
	Order by 1 

-- Leyenda --
-- DI : 05/09/12 <Creacion del SP>

GO

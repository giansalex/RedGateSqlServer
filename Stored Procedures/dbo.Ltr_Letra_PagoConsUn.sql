SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_Letra_PagoConsUn]

@RucE nvarchar(11),
@Cd_Ltr int,

@msj varchar(100) output

AS

Select 
	*
From 
	Letra_Pago
Where
	RucE=@RucE and Cd_Ltr=@Cd_Ltr


-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
	
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_TipActividad_Cons] 
@msj varchar(100) output  
AS 

SELECT [Cd_TA], [Descrip], [NomCorto], [Estado] 
	FROM   [dbo].[TipActividad]
GO

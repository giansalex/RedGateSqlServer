SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_EstadoAct_Cons] 
@msj varchar(100) output   
AS 
	SELECT [Cd_EA], [Descrip], [NomCorto], [Estado] 
	FROM   [dbo].[EstadoAct] 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Uc_Servicio2Cons]
@RucE NVARCHAR(11),
@msj varchar(100) output
AS

SELECT s.Cd_Srv,s.Nombre FROM Servicio2 s
WHERE s.RucE=@RucE
GO

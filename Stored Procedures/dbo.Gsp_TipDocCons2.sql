SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gsp_TipDocCons2]
@RucE nvarchar(11),
@msj varchar(100) OUTPUT
as
SELECT 
	TipDoc.Cd_TD,
	Descrip  FROM TipDoc INNER JOIN Serie s ON TipDoc.Cd_TD = s.Cd_TD  INNER JOIN Numeracion n ON s.RucE = n.RucE AND s.Cd_Sr = n.Cd_Sr WHERE
	 s.RucE=@RucE GROUP BY TipDoc.Cd_TD, Descrip
GO

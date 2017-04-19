SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_UsuXEmp_ConsUn]
@RucE nvarchar(11)
As
SELECT Distinct    Usu.*
FROM         GrupoAcceso As Ga INNER JOIN
                      AccesoM AS Am ON Ga.Cd_GA = Am.Cd_GA INNER JOIN
                      AccesoE As Ae ON Ga.Cd_GA = Ae.Cd_GA INNER JOIN
                      Perfil As Prf INNER JOIN
                      Usuario As Usu ON Prf.Cd_Prf = Usu.Cd_Prf ON Ae.Cd_Prf = Prf.Cd_Prf
Where Ae.RucE = @RucE
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_Usuarios_ConsXRuc]
@RucE nvarchar(11)
As
SELECT     distinct Usuario.*
FROM         AccesoE INNER JOIN
                      Perfil ON AccesoE.Cd_Prf = Perfil.Cd_Prf INNER JOIN
                      Usuario ON Perfil.Cd_Prf = Usuario.Cd_Prf
WHERE
			AccesoE.RucE = @RucE And 
			Usuario.Cd_Prf <> case when AccesoE.RucE <> '11111111111' then '001' else '000' end
			Order by 1
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Vta_UsuariosAut_LP]
@RucE NVARCHAR(11),
@Cd_LP char(10)
As
SELECT     Usuario.NomUsu
FROM         ListaPrecio_Autorizados INNER JOIN
                      Usuario ON ListaPrecio_Autorizados.NomUsu = Usuario.NomUsu
WHERE
			ListaPrecio_Autorizados.Cd_LP = @Cd_LP And
			ListaPrecio_Autorizados.RucE = @RucE
GO

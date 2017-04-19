SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ges_CantidadRegistro_X_Usuario_Det]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Usuarios nvarchar(100),

@msj varchar(100) output

AS

SELECT
	v.Prdo,
	v.UsuCrea As NomUsu,
	u.NomComp As Empleado,
	v.Cd_Fte As Fte
FROM
	Voucher v
	LEFT JOIN Usuario u ON u.NomUsu=v.UsuCrea
WHERE
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and v.Prdo=@PrdoD
 and v.UsuCrea=@Usuarios
ORDER by
	v.Cd_Fte

GO

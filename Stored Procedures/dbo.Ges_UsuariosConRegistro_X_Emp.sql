SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ges_UsuariosConRegistro_X_Emp]

@RucE nvarchar(11),
@Ejer nvarchar(4),

@msj varchar(100) output

AS
/*
DECLARE @RucE nvarchar(11)
DECLARE @Ejer nvarchar(4)

SET @RucE='11111111111'
SET @Ejer='2011'
*/

SELECT
	v.UsuCrea As NomUsu,
	u.NomComp As Empleado
FROM
	Voucher v
	LEFT JOIN Usuario u ON u.NomUsu=v.UsuCrea
WHERE
	v.RucE=@RucE
	and v.Ejer=@Ejer
GROUP BY
	v.UsuCrea,u.NomComp
ORDER BY 
	u.NomComp
-- Leyenda --
-- DI : 29/04/2011 <Creacion de procedimiento almacenado>

GO

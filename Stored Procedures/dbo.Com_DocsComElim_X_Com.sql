SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_DocsComElim_X_Com]

@RucE nvarchar(11),
--@Id_Doc int,
@Cd_Com char(10),

@msj varchar(100) output

AS


-- Verificando si existe algun registro de la venta definida
if exists (Select * from DocsCom where RucE=@RucE and Cd_Com=@Cd_Com)
Begin	
	delete from DocsCom where RucE=@RucE and Cd_Com=@Cd_Com

	if @@rowcount <= 0
		Set @msj = 'Hubo error al eliminar documentos de la compra '+@Cd_Com
End

-- Leyedan --
-- DI : 19/12/2010 <Creacion del procedimiento almacenado>





GO

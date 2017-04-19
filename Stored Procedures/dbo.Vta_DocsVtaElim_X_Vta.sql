SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_DocsVtaElim_X_Vta]

@RucE nvarchar(11),
--@Id_Doc int,
@Cd_Vta nvarchar(10),

@msj varchar(100) output

AS


-- Verificando si existe algun registro de la venta definida
if exists (Select * from DocsVta where RucE=@RucE and Cd_Vta=@Cd_Vta)
Begin	
	delete from DocsVta where RucE=@RucE and Cd_Vta=@Cd_Vta

	if @@rowcount <= 0
		Set @msj = 'Hubo error al eliminar documentos de la venta '+@Cd_Vta
End

-- Leyedan --
-- DI : 17/12/2010 <Creacion del procedimiento almacenado>


GO

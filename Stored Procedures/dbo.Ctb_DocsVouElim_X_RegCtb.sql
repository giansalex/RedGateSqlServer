SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_DocsVouElim_X_RegCtb]

@RucE nvarchar(11),
--@Id_Doc int,
@RegCtb nvarchar(15),

@msj varchar(100) output

AS


-- Verificando si existe algun registro de la venta definida
if exists (Select * from DocsVou where RucE=@RucE and RegCtb=@RegCtb)
Begin	
	delete from DocsVou where RucE=@RucE and RegCtb=@RegCtb

	if @@rowcount <= 0
		Set @msj = 'Hubo error al eliminar documentos del voucher '+@RegCtb
End

-- Leyedan --
-- DI : 19/12/2010 <Creacion del procedimiento almacenado>




GO

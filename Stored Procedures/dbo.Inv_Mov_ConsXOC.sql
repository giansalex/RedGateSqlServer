SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Mov_ConsXOC]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_OC char(10),
@msj varchar(100) output
as if exists (select * from Inventario where RucE=@RucE and Ejer=@Ejer and Cd_OC=@Cd_OC)
	set @msj = 'No se puede modificar Orden de Compra porque está relacionada a un Movimiento de Inventario'
else
set @msj = ''

print @msj
GO

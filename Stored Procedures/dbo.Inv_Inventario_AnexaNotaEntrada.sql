SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Inv_Inventario_AnexaNotaEntrada]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from Inventario where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtb)
	set @msj = 'No existe el Movimiento de Inventario especificado'
else
begin
	update Inventario set  Cd_GR = @Cd_GR where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtb
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupProdElim]
@RucE nvarchar(11),
@Cd_CGP char(3),
@msj varchar(100) output
as
if not exists (select * from ComisionGrupProd Where RucE=@RucE and Cd_CGP=@Cd_CGP)
	set @msj = 'Comision no existe'
else
begin
	delete from ComisionGrupProd Where RucE=@RucE and Cd_CGP=@Cd_CGP

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Producto no pudo ser eliminado'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXCompraElim]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Com char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Com=@Cd_Com)
	set @msj = 'Guia por Compra no existe'
else
begin
	delete GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Com=@Cd_Com
	if @@rowcount <= 0
		set @msj = 'Linea no pudo ser eliminado'
	else
		delete GuiaRemisionDet where RucE=@RucE and Cd_GR=@Cd_GR and Cd_Com=@Cd_Com
end
print @msj

-- Leyenda --
-- FL : 2010-10-20 : <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetElim]
@RucE nvarchar(11),
@Cd_GR char(10),
@Item int,
@msj varchar(100) output

as
if not exists (select * from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR and Item = @Item)
	set @msj = 'Detalle de Guia de Remision no existe'
else
begin
	delete GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR and Item = @Item
	
	if @@rowcount <= 0
		set @msj = 'Detalle de Guia de Remision no pudo ser elimanda'
	else
		delete GuiaXVenta where RucE = @RucE and Cd_GR=@Cd_GR and Cd_Vta not in(  select Cd_Vta from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR)
				
end
print @msj

-- Leyenda --
-- PP : 2010-04-22 12:24:31.507	: <Creacion del procedimiento almacenado>

GO

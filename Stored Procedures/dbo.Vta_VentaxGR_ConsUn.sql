SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_VentaxGR_ConsUn]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from GuiaxVenta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	Set @msj = 'No existe Venta asociada a Guia'
else
begin
select * from GuiaxVenta where RucE=@RucE and Cd_Vta=@Cd_Vta
end

-- Leyenda --
--Solo consulta si hay venta asociada a guia
-- FL : 2011-08-25 : <Creacion del procedimiento almacenado>

GO

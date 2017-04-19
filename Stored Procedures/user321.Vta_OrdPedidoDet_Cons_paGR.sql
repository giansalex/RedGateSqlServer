SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Vta_OrdPedidoDet_Cons_paGR]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as

if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP)
	Set @msj = 'No existe Orden de Pedido'
else
begin
	select o.Cd_Prod, p.CodCo1_ as CodCom,o.Descrip, p.Descrip as DescripProd, o.ID_UMP, o.Cant, pu.DescripAlt as DescripUMP, pu.Factor, pu.PesoKg
	from OrdPedidoDet o
		left join Prod_UM pu on o.RucE = pu.RucE and o.Cd_Prod = pu.Cd_Prod and o.ID_UMP = pu.ID_UMP
		left join Producto2 p on p.RucE = o.RucE and p.Cd_Prod = o.Cd_Prod
	where o.RucE = @RucE and o.Cd_OP = @Cd_OP and o.Cd_Prod is not null
	set @msj = ''
end

-- LEYENDA
-- CAM 07/06/2012 Creacion
-- exec user321.Vta_OrdPedidoDet_Cons_paGR '11111111111','OP00000140',''

GO

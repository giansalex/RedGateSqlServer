SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Vta_OrdPedidoDet_Cons_paVta]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as

if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP)
	Set @msj = 'No existe Orden de Pedido'
else
begin
	select o.Cd_Prod, o.Cd_Srv, p.CodCo1_ as CodCo, o.Descrip, o.ID_UMP, o.PU, o.Cant, o.Valor, o.DsctoP, o.DsctoI, o.IGV, o.Total, o.Cd_Alm, o.Obs
	,pu.DescripAlt as UMP_, o.Cd_CC, o.Cd_SC, o.Cd_SS
	from OrdPedidoDet o
		left join Prod_UM pu on o.RucE = pu.RucE and o.Cd_Prod = pu.Cd_Prod and o.ID_UMP = pu.ID_UMP
		left join Producto2 p on p.RucE = o.RucE and p.Cd_Prod = o.Cd_Prod 
	where o.RucE = @RucE and o.Cd_OP = @Cd_OP
	set @msj = ''
end
/*
exec 'OP00000248'
exec user321.Vta_OrdPedidoDet_Cons_paVta '11111111111','OP00000187',''

select * from OrdPedido where RucE = '11111111111'
*/
GO

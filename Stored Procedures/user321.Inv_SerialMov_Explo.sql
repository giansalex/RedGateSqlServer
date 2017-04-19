SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_SerialMov_Explo]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@msj varchar(100) output
as

/*
if not exists(select top 1 *from SerialMov where RucE=@RucE and Cd_Prod=@Cd_Prod and Serial=@Serial)
	set @msj='no contiene Movimientos'
else
begin
*/
select 	sm.Cd_Prod,
	p2.Nombre1 Producto,
	sm.Serial,
	inv.RegCtb,
	sm.Cd_Inv,
	g.Cd_GR,
	case when inv.IC_ES='E' then 'Entrada' when inv.IC_ES='S' then 'Salida' end as IC_ES,
	/*Convert(nvarchar,*/inv.FecMov/*,103)*/ FecMov,sm.Cd_Vta, vta.FecReg VtaFecReg, sm.Cd_Com, com.FecReg ComFecReg
from 
	SerialMov sm inner join Producto2 p2 on p2.RucE=sm.RucE and p2.Cd_Prod=sm.Cd_Prod
	left join Inventario inv on inv.RucE=sm.RucE and inv.Cd_Inv=sm.Cd_Inv
	left join Compra com on com.RucE = sm.RucE and com.Cd_Com = sm.Cd_Com
	left join Venta vta on vta.RucE = vta.RucE and vta.Cd_Vta = sm.Cd_Vta
	left join GuiaRemision g on g.RucE = inv.RucE and inv.Cd_GR=g.Cd_GR
	
where 
	sm.RucE=@RucE and sm.Cd_Prod=@Cd_Prod and sm.Serial=@Serial
order by
	inv.FecMov,
	inv.RegCtb,
	sm.Serial asc
-- end
-- Leyenda --
-- JJ : 2011-03-15 : <Creacion del procedimiento almacenado>
-- MM : 2011-04-20 : <Modificacion : se omitio el mensaje cuando la serie no tiene movimiento>
-- 6






GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_SerialMov_Explo3]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@msj varchar(100) output
as

--exec [user321].[Inv_SerialMov_Explo2] '11111111111','PD00012','7613031882403',null
--select top 1 Cd_Com from serialmov where RucE='11111111111' and Cd_Prod='PD00012' and Serial='7613031882403'
--select top 1 Cd_Vta from serialmov where RucE='11111111111' and Cd_Prod='PD00012' and Serial='7613031882403'
--select top 1 Cd_Inv from serialmov where RucE='11111111111' and Cd_Prod='PD00012' and Serial='7613031882403'
--------------------------------------------------------------------------------------------------------------------
--select * from serial where RucE='11111111111' and Cd_Prod='PD00004' and Serial='22'
--delete serial where RucE='11111111111' and Cd_Prod='PD00004' and Serial='22'


		select 	sm.Cd_Prod,
			p2.Nombre1 Producto,
			sm.Serial,
			isnull(inv.RegCtb,isnull(vta.RegCtb,isnull(com.RegCtb,''))) as RegCtb,
			sm.Cd_Inv, 
			isnull(g.Cd_GR,'Sin Documento') as Cd_GR,
			case 
			when inv.IC_ES='E' then 'Entrada' 
			when inv.IC_ES='S' then 'Salida'
			when sm.Cd_Com is not null then 'Entrada'
			when sm.Cd_Vta is not null then 'Salida' 
			end as IC_ES,
			isnull(inv.FecMov,isnull(vta.FecMov,isnull(com.FecMov,''))) as FecMov,
			sm.Cd_Vta, vta.FecReg VtaFecReg, sm.Cd_Com, com.FecReg ComFecReg
		from 
			SerialMov sm inner join Producto2 p2 on p2.RucE=sm.RucE and p2.Cd_Prod=sm.Cd_Prod
			left join Inventario inv on inv.RucE=sm.RucE and inv.Cd_Inv=sm.Cd_Inv
			left join Compra com on com.RucE = sm.RucE and com.Cd_Com = sm.Cd_Com
			left join Venta vta on vta.RucE = sm.RucE and vta.Cd_Vta = sm.Cd_Vta
			left join GuiaRemision g on g.RucE = inv.RucE and inv.Cd_GR=g.Cd_GR
			
		where 
			sm.RucE=@RucE and sm.Cd_Prod=@Cd_Prod and sm.Serial=@Serial
		order by
			FecMov,
			inv.RegCtb,com.RegCtb,vta.RegCtb,
			sm.Serial asc



-- end
-- Leyenda --
-- JJ : 2011-03-15 : <Creacion del procedimiento almacenado>
-- MM : 2011-04-20 : <Modificacion : se omitio el mensaje cuando la serie no tiene movimiento>
-- Exec user321.Inv_SerialMov_Explo '11111111111','PD00001','SC-001',null
GO

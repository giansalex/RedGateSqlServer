SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Vta_DesAnula_Upd '11111111111','2011','VTGE_RV03-00015',null

CREATE procedure [dbo].[Vta_DesAnula_Upd]
@RucE nvarchar(11),
@Ejer varchar(4),
@RegCtb nvarchar(15),
@msj varchar(100) output
as



--haciendo update a ventas
update Venta set IB_Anulado=0, MtvoBaja = null where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb

--haciendo update a su voucher contable directo
update Voucher set IB_Anulado=0 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
--haciendo update a sus vouchers indirectos(cancelaciones,etc)
--if @@ROWCOUNT <=0
--	set @msj='Venta con registro contable '+@RegCtb+' no pudo ser desanulada'


--PV: 2017-04-18: se agregó para que se limpie el MtvoBaja
GO

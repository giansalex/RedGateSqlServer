SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_CreaProductoxLote]
@Id_ProductoxLote int output,
@RucE nvarchar(11),
@Cd_Lote char(10),
@RegCtbInv nvarchar(15),
@Ejer nvarchar(4),
@Cd_Prod nchar(10),
@Cant numeric(13,3),
@msj varchar(100) output
as

insert into ProductoxLote (RucE,RegCtbInv,Cd_Lote,Cd_Prod,Cant,Ejer)
		values (@RucE,@RegCtbInv,@Cd_Lote,@Cd_Prod,@Cant,@Ejer)


-- LEYENDA
-- CAM 29/11/2012 creacion
--select * from OrdCompra where RucE= '11111111111' and NroOC = 'OC00000524'

-- select * from Lote
-- select * from ProductoxLote
-- delete from Lote where Cd_Lote = 'LT00000003'
-- delete from ProductoxLote
-- exec Inv_Lote_Crea '11111111111','','lote001','nada1','05/08/2012',''
-- select * from Inventario where ruce = '11111111111'
GO

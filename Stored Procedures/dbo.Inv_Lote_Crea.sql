SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--ESTE METODO SOLO DEBE SER USADO CUANDO SE QUIERA GUARDAR COSTOS EN DOLARES Y SOLES
CREATE procedure [dbo].[Inv_Lote_Crea]
@RucE nvarchar(11),
@Cd_Lote char(10) output,
@NroLote varchar(20),
@Descripcion nvarchar(200),
@FecCaducidad datetime,
@msj varchar(100) output

as
set @msj = 'Funcionalidad en mantenimiento. Disculpe las molestias.'
/*
set @Cd_Lote = dbo.Cd_Lote(@RucE)
insert into Lote (RucE,Cd_Lote,NroLote,Descripcion,FecCaducidad)
values (@RucE,@Cd_Lote,@NroLote,@Descripcion,@FecCaducidad)

if @@rowcount <= 0
	set @msj = 'Lote no pudo ser registrado.'	
	
print @Cd_Lote
print 'msj:' + @msj
*/
-- LEYENDA
-- CAM 11/08/2012 creacion

-- select * from Lote
-- delete from Lote
-- exec Inv_Lote_Crea '11111111111','','lote001','nada1','05/08/2012',''
-- select * from Inventario where ruce = '11111111111'
GO

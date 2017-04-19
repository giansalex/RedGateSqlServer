SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_Crea_1]
@RucE nvarchar(11),
@Cd_Lote char(10) output,
@Cd_Prov char(7),
@NroLote varchar(20),
@Descripcion nvarchar(200),
@FecCaducidad datetime,
@UsuCrea varchar(10),
@FecReg datetime,
@msj varchar(100) output

as
--set @msj = 'Funcionalidad en mantenimiento. Disculpe las molestias.'
if not exists (select * from Lote where RucE = @RucE and Cd_Prov = @Cd_Prov and NroLote = @NroLote)
begin
	set @Cd_Lote = dbo.Cd_Lote(@RucE)
	insert into Lote (RucE,Cd_Prov,Cd_Lote,NroLote,Descripcion,FecCaducidad,UsuCrea,FecReg)
		values (@RucE,@Cd_Prov,@Cd_Lote,@NroLote,@Descripcion,@FecCaducidad,@UsuCrea,GETDATE())
end
else
begin
	select @Cd_Lote = Cd_Lote from Lote where RucE = @RucE and Cd_Prov = @Cd_Prov and NroLote = @NroLote
end
-- LEYENDA
-- CAM 29/11/2012 creacion

-- select * from Lote
-- delete from Lote
-- exec Inv_Lote_Crea '11111111111','','lote001','nada1','05/08/2012',''
-- select * from Inventario where ruce = '11111111111'
GO

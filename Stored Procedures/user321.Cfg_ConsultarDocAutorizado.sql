SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_ConsultarDocAutorizado]
@RucE nvarchar (11),
@Cd_Doc char(10),
@TipoDoc int,
@autorizado bit output

AS
--------------------------------------------------
declare @Cadena nvarchar(1000)
declare @Tabla varchar(20)
declare @Campo varchar(10)
--------------------------------------------------

if(@TipoDoc = 0)
begin
	set @Tabla = 'OrdCompra'
	set @Campo = 'Cd_OC'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'OrdPedido'
	set @Campo = 'Cd_OP'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'SolicitudCom'
	set @Campo = 'Cd_SCo'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'SolicitudReq'
	set @Campo = 'Cd_SR'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'OrdFabricacion'
	set @Campo = 'Cd_OF'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'Cotizacion'
	set @Campo = 'Cd_Cot'
end

set @cadena = 'select @auto = isnull((case(TipAut) when 0 then 1 else IB_Aut end),0) from '+@Tabla+' where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''
print @cadena
exec sp_executesql @cadena, N'@auto bit output', @autorizado output

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_CambiarTipoAut]
@RucE nvarchar (11),
@Cd_Doc char(10),
@TipoDoc int,
@TipAut int,
@msj varchar (100) output

AS
--------------------------------------------------
declare @Cadena nvarchar(500)
declare @Tabla varchar(20)
declare @Campo varchar(10)
--------------------------------------------------
declare @CdDMA char(2)
declare @num int
--------------------------------------------------
if(@TipoDoc = 0)
begin	
	set @Tabla = 'OrdCompra'
	set @Campo = 'Cd_OC'
	set @CdDMA = 'OC'
end
else if(@TipoDoc = 1)
begin	
	set @Tabla = 'OrdPedido'
	set @Campo = 'Cd_OP'
	set @CdDMA = 'OP'
end
else if(@TipoDoc = 2)
begin	
	set @Tabla = 'SolicitudCom'
	set @Campo = 'Cd_SCo'
	set @CdDMA = 'SC'
end
else if(@TipoDoc = 3)
begin	
	set @Tabla = 'SolicitudReq'
	set @Campo = 'Cd_SR'
	set @CdDMA = 'SR'
end
else if(@TipoDoc = 4)
begin	
	set @Tabla = 'OrdFabricacion'
	set @Campo = 'Cd_OF'
	set @CdDMA = 'OF'
end
else if(@TipoDoc = 5)
begin	
	set @Tabla = 'Cotizacion'
	set @Campo = 'Cd_Cot'
	set @CdDMA = 'CT'
end
----------------------------------------------------------------------------------------------------
set @Cadena =	'update ' + @Tabla + ' set TipAut = ' + convert(varchar,@TipAut) + ' where RucE = ''' + 
				@RucE + ''' and ' + @Campo + ' = ''' + @Cd_Doc + ''''
exec sp_executesql @Cadena
print @Cadena

--exec Cfg_CambiarTipoAut '11111111111', 'SC00000137', 2, 5, null
GO

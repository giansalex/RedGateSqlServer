SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_CalcularCampoFormula]
@RucE nvarchar(11),
@Codigo char(10),
@Id_CTb int,
@msj varchar(100) output
as
/*
declare @RucE char(11)
declare @Codigo char(10)
declare @Id_CTb int
set @Id_CTb = 7
set @RucE = '11111111111'
set @Codigo = 'VT00000463'
*/
declare @formula nvarchar(1000)
declare @tabla nvarchar(100)
declare @campoCodigo nvarchar(100)
declare @cd_Tab char(4)

select @cd_Tab = ct.Cd_Tab, @formula = cc.Fmla from CfgCampos cc
inner join CampoTabla ct on cc.Id_CTb = ct.Id_Ctb
where cc.Id_Ctb = @Id_CTb and cc.Id_TDt = '9'

--Para seleciconar la tabla
set @tabla = (select case @cd_Tab
when 'VT01' then 'Venta'
when 'VT07' then 'OrdPedido'
when 'VT09' then 'Cotizacion'
when 'VT11' then 'GuiaRemision'
when 'VT13' then 'Cliente2'
when 'VT14' then 'Vendedor2'
when 'VT15' then 'Transportista'
when 'VT16' then 'Producto2'
when 'VT17' then 'Servicio2'
when 'CP01' then 'Compra'
when 'CP03' then 'SolicitudReq'
when 'CP05' then 'SolicitudCom'
when 'CP07' then 'OrdCompra'
when 'CP09' then 'GuiaRemision'
when 'CP11' then 'Proveedor2'
when 'CP12' then 'Servicio2'
when 'XX01' then 'Almacen'
when 'XX02' then 'Marca'
when 'XX03' then 'Clase'
when 'XX06' then 'OrdFabricacion'
--when 'XX04' then 'ClaseSub'
--when 'XX05' then 'ClaseSubSub'
else 'Other'
end)
print @tabla

--Para seleccionar el campo
set @campoCodigo = (select case @cd_Tab
when 'VT01' then 'Cd_Vta'
when 'VT07' then 'Cd_OP'
when 'VT09' then 'Cd_Cot'
when 'VT11' then 'Cd_GR'
when 'VT13' then 'Cd_Clt'
when 'VT14' then 'Cd_Vdr'
when 'VT15' then 'Cd_Tra'
when 'VT16' then 'Cd_Prod'
when 'VT17' then 'Cd_Srv'
when 'CP01' then 'Cd_Com'
when 'CP03' then 'Cd_SR'
when 'CP05' then 'Cd_SC'
when 'CP07' then 'Cd_OC'
when 'CP09' then 'Cd_GR'
when 'CP11' then 'Cd_Prv'
when 'CP12' then 'Cd_Srv'
when 'XX01' then 'Cd_Alm'
when 'XX02' then 'Cd_Mca'
when 'XX03' then 'Cd_CL'
when 'XX06' then 'Cd_OF'
--when 'XX04' then 'Cd_CLS'
--when 'XX05' then 'Cd_CLSS'
else 'Other'
end)
print @campoCodigo

if @formula = '' or @formula is null
	set @msj = 'No es campo formula'
else
begin
	declare @sql1 nvarchar(400)
	set @sql1 = 'select @Result = (' + @formula + ') from '+ @tabla +' 
		     where RucE = ''' + @RucE + ''' and '+ @campoCodigo +' = ''' + @Codigo + ''''
	print @sql1
	declare @OResult varchar(100)
	exec sp_executesql @sql1, N'@Result varchar(100) output', @OResult output
	
	declare @nomCol char(4)
	select @nomCol = NomCol from CampoTabla where Id_Ctb = @Id_CTb 
	print @OResult

	declare @sql2 nvarchar(400)
	set @sql2 = N'update '+ @tabla +' set ' + @nomCol + ' = ''' + @OResult + ''' 
		      where RucE = ''' + @RucE + ''' and '+ @campoCodigo +' = ''' + @Codigo + ''''
	print 'Estuve aki'
	print @sql2
	exec sp_executesql @sql2
end

print @msj
-- MP : 25-01-2011 : <Creacion del procedimiento almacenado>
-- MP : 26-01-2011 : <Modificacion del procedimiento almacenado>
-- MP : 27-01-2011 : <Modificacion del procedimiento almacenado>
-- MP : 03-02-2011 : <Modificacion del procedimiento almacenado>
--DEMO
/*
exec Cfg_CalcularCampoFormula '11111111111', 'VT00000463', '7', null
select * from CfgCampos
SELECT * FROM OrdFabricacion

select * from Cotizacion
select * from CotizacionDet

select * from OrdCompra
select * from OrdCompraDet

select * from GuiaRemision
select * from GuiaRemisionDet
*/

--exec Cfg_CalcularCampoFormula '11111111111','VT00000532', 7, null








GO

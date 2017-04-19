SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CopiaDatosAUnaEmpresa]
@RucEAnt nvarchar(11),
@RucE nvarchar(11),
@msj varchar(100) output
as

--declare @RucEAnt nvarchar(11)
--declare @RucE nvarchar(11)

--set @RucEAnt = '20538349730'--KAESER
--set @RucE = '33333333333'

delete from Area where RucE = @RucE
delete from CCSubSub where RucE = @RucE
delete from CCSub where RucE = @RucE
delete from CCostos where RucE = @RucE
delete from PlanCtasDef where RucE = @RucE
delete from PlanCtas where RucE = @RucE
delete from AccesoE where RucE = @RucE
delete from Periodo where RucE = @RucE

exec CopiaDatosxTabla @RucEAnt, @RucE, 'Periodo'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CfgCampos'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CfgEnvCorreo'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CfgEnvCot'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CfgEnvSC'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CfgGeneral'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Ccostos'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CCSub'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CCSubSub'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'PlanCtasDef'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'SolicitudCom'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'SCxProv'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'SolicitudComDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'TipDocES'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'MtvoIngSal'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Asiento'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'GrupoSrv'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Servicio2'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Proveedor2'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Vendedor2'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Cliente2'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Contacto'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ServProv'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ServProvPrecio'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Vinculo'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'PersonaRef'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Almacen'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'AlmacenStock'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Cotizacion'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CotizacionDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CotizacionFormato'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CotizacionProdDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'OrdPedido'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'OrdPedidoDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Area'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Serie'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Numeracion'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ComisionGrupProd'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Marca'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Producto2'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'DocsCom'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'DocsVta'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Clase'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ClaseSub'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ClaseSubSub'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'GuiaRemision'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'DirecEnt'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'GuiaRemisionDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Transportista'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'GRPtoLlegada'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'GuiaxCompra'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'GuiaxVenta'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Prod_UM'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ProdProv'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ProdProvPrecio'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Precio'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'PrecioHist'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'Presupuesto'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'CarteraProd'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'carteraProdDet_S'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CarteraProdDet_P'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'ComisionConfig'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ComisionGrupVdr'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ComisionGrupCte'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ProdCombo'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'ProdSustituto'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'OrdCompra'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'OrdCompraDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Venta'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'VentaDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Compra'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CompraDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Inventario'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'SolicitudReq'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'SolicitudReqDet'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'AuxiliarRM'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Campo'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'CampoV'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'Voucher'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'DocsVou'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'VoucherRM'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'VoucherDR'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'PlanCtas'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'AmarreRpt'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Auxiliar'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Cobro'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'VentaRM'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'VentaCfg'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'AmarreRpt'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Vendedor'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Proveedor'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Cliente'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'AccesoE'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'AmarreCta'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'Articulo'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'Producto'

exec CopiaDatosxTabla @RucEAnt, @RucE, 'Servicio'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'PrecioSrv'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'TipMant'
exec CopiaDatosxTabla @RucEAnt, @RucE, 'MantenimientoGN'


--ANOTACION: ESTO SOLO FUNCIONA SI LA EMPRESA ES NUEVA
--MP : 04/04/2012 : <Creacion del procedimiento almacenado>
GO

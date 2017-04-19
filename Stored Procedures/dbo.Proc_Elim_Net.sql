SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select * from empresa where ruc=''

----------------------------------------------------

CREATE proc [dbo].[Proc_Elim_Net]
@RucE nvarchar(11)
AS
delete from AccesoE where RucE = @RucE
--delete from AccesoM
delete from AlmacenStock where RucE = @RucE
delete from AmarreCta where RucE = @RucE
delete from AmarreRpt where RucE = @RucE
delete from Articulo where RucE = @RucE
delete from Asiento where RucE = @RucE
delete from AutCot where RucE = @RucE
delete from AutOC where RucE = @RucE
delete from AutOF where RucE = @RucE
delete from AutOP where RucE = @RucE
delete from AutSC where RucE = @RucE
delete from AutSR where RucE = @RucE
delete from AuxiliarRM where RucE = @RucE
delete from Banco where RucE = @RucE
delete from CampoV where RucE = @RucE
delete from CarteraProdDet_P where RucE = @RucE
delete from CarteraProdDet_S where RucE = @RucE
--delete from CfgAutsXUsuario
delete from CfgCampos where RucE = @RucE
delete from CfgEmpsBase where RucBase = @RucE
delete from CfgEnvCot where RucE = @RucE
delete from CfgEnvSC where RucE = @RucE
delete from CfgGeneral where RucE = @RucE
--delete from CfgSistema
--delete from CfgUsu
delete from Cobro where RucE = @RucE
delete from ComisionConfig where RucE = @RucE
delete from CompraDet where RucE = @RucE
delete from ConceptoDetracHist where RucE = @RucE
delete from Contacto where RucE = @RucE
--delete from ControlGrupos
delete from CotizacionProdDet where RucE = @RucE
delete from CptoCostoOFDoc where RucE = @RucE
delete from CptoDetxProv where RucE = @RucE
delete from DirecEnt where RucE = @RucE
delete from DirecTrans where RucE = @RucE
delete from DocsCom where RucE = @RucE
delete from DocsVou where RucE = @RucE
delete from DocsVta where RucE = @RucE
delete from EnvEmbOF where RucE = @RucE
delete from FormulaDet where RucE = @RucE
delete from FrmlaOF where RucE = @RucE
--delete from Fuente
delete from GeneralRM where RucE = @RucE
delete from GRPtoLlegada where RucE = @RucE
delete from GuiaRemisionDet where RucE = @RucE
delete from GuiaXCompra where RucE = @RucE
delete from GuiaXVenta where RucE = @RucE
delete from Inventario where RucE = @RucE
delete from Numeracion where RucE = @RucE
delete from OrdCompraDet where RucE = @RucE
delete from OrdPedidoDet where RucE = @RucE
--delete from PermisosCfgXPerfil
--delete from PermisosxGP
delete from PersonaRef where RucE = @RucE
delete from PlanCtas where RucE = @RucE
delete from PlanCtasDef where RucE = @RucE
delete from PrdoCons where RucE = @RucE
delete from PrecioHist where RucE = @RucE
delete from PrecioSrv where RucE = @RucE
delete from PresupCpto where RucE = @RucE
delete from PresupFC where RucE = @RucE
delete from Presupuesto where RucE = @RucE
delete from ProdCombo where RucE = @RucE
delete from ProdProvPrecio where RucE = @RucE
delete from ProdSustituto where RucE = @RucE
delete from SCxProv where RucE = @RucE
delete from SerialMov where RucE = @RucE
delete from SeriesXArea where RucE = @RucE
delete from ServProvPrecio where RucE = @RucE
delete from SolicitudComDet where RucE = @RucE
delete from SolicitudReqDet where RucE = @RucE
--delete from TablaLocal
--delete from TablaTemp
--delete from Tasas
--delete from TipCam
--delete from TipCamRM
--delete from TipGasto
--delete from UDepa
--delete from UDist
--delete from UProv
delete from VentaCfg where RucE = @RucE
delete from VentaDet where RucE = @RucE
delete from VentaRM where RucE = @RucE
delete from Voucher where RucE = @RucE
delete from VoucherDR where RucE = @RucE
delete from VoucherRM where RucE = @RucE
delete from CptoCostoOF where RucE = @RucE
delete from CptoCosto where RucE = @RucE
--delete from EstadoOF
delete from OrdFabricacion where RucE = @RucE
delete from Formula where RucE = @RucE
delete from Compra where RucE = @RucE
delete from CotizacionDet where RucE = @RucE
--delete from IndicadorValor
delete from Precio where RucE = @RucE
delete from ProdProv where RucE = @RucE
delete from ServProv where RucE = @RucE
delete from Prod_UM where RucE = @RucE
delete from ConceptosDetrac where RucE = @RucE
delete from Serial where RucE = @RucE
delete from Producto2 where RucE = @RucE
delete from ClaseSubSub where RucE = @RucE
delete from ClaseSub where RucE = @RucE
delete from Clase where RucE = @RucE
delete from Servicio2 where RucE = @RucE
delete from Servicio where RucE = @RucE
delete from GrupoSrv where RucE = @RucE
delete from Proveedor2 where RucE = @RucE
delete from Proveedor where RucE = @RucE
delete from Venta where RucE = @RucE
delete from OrdPedido where RucE = @RucE
delete from Cotizacion where RucE = @RucE
delete from Cliente where RucE = @RucE
delete from Vendedor where RucE = @RucE
delete from Auxiliar where RucE = @RucE
delete from Vendedor2 where RucE = @RucE
delete from OrdCompra where RucE = @RucE
delete from SolicitudCom where RucE = @RucE
delete from SolicitudReq where RucE = @RucE
delete from Area where RucE = @RucE
delete from CCSubSub where RucE = @RucE
delete from CCSub where RucE = @RucE
delete from CCostos where RucE = @RucE
delete from CarteraProd where RucE = @RucE
delete from Periodo where RucE = @RucE
delete from Almacen where RucE = @RucE
delete from GuiaRemision where RucE = @RucE
delete from CotizacionFormato where RucE = @RucE
delete from CfgEnvCorreo where RucE = @RucE
delete from Campo where RucE = @RucE
delete from Cliente2 where RucE = @RucE
delete from MtvoIngSal where RucE = @RucE
delete from Empresa where Ruc = @RucE
--delete from Moneda
--delete from CampoT
--delete from CampoTabla
--delete from Tabla
--delete from Categoria
------------------------ Esta tabla no tiene RucE y es necesario que se elimine
delete CfgNivelAut where id_Aut in(select id_Aut from CfgAutorizacion where RucE=@RucE)
------------------------
delete from CfgAutorizacion where RucE = @RucE
delete from ComisionGrupCte where RucE = @RucE
delete from ComisionGrupVdr where RucE = @RucE
delete from ComisionGrupProd where RucE = @RucE
--delete from DocMovAuts
--delete from EntidadFinanciera
--delete from Estado
--delete from EstadoCot
--delete from EstadoSC
--delete from EstadoSR
--delete from EstadoOC
--delete from EstadoOP
--delete from FormaPC
--delete from GrupoPermisos
--delete from GrupoAcceso
--delete from IndicadorAfecto
--delete from IndicadorAfectoVta
--delete from Linea
--delete from Menu
--delete from Modulo
delete from Marca where RucE = @RucE
delete from Transportista where RucE = @RucE
--delete from Pais
--delete from Usuario
--delete from Perfil
--delete from Permisos
--delete from PermisosCfg
delete from Producto where RucE = @RucE
--delete from RubrosRpt
delete from Serie where RucE = @RucE
--delete from TipoReporte
--delete from TipDoc
--delete from TipAux
delete from TipDocES where RucE = @RucE
--delete from TipDocIdn
--delete from TipoDato
--delete from TipoMov
--delete from TipoOperacion
--delete from TipoExistencia
--delete from UnidadMedida
delete from Vinculo where RucE = @RucE

--PP/FL : 12/05/2011 <creacion de sp>
GO

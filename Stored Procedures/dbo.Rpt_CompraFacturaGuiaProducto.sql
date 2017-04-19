SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[Rpt_CompraFacturaGuiaProducto] 
					 @RucEmp nvarchar(11)
					,@fecIni datetime
					,@fecFin datetime
					,@NroCol varchar(2) 
					,@TipOrd nvarchar(4)
					,@cd_prv char(7)
					,@Cd_Prod char(7)
					,@Cd_FPC nvarchar(2)
					,@cd_Mda nvarchar(2)
					,@Est_Imp bit
					,@Campo varchar(100)

as




declare @Sql nvarchar(4000), @Impt varchar(3)

/************************* VALIDACIONES *****************************/
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @cd_prv is null set @cd_prv = '' --Codigo Proveedor
if @Cd_Prod IS NULL sET @Cd_Prod = '' --  CODIGO PRODUCTO
if @Cd_FPC IS NULL SET @Cd_FPC = '' --  CODIGO DE FORMA DE PAGO
if @cd_Mda Is null or @cd_Mda = '03' set @cd_Mda = '' -- CODIGO DE MONEDA
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
/************************* VALIDACIONES *****************************/

SELECT  Empresa.Ruc, Empresa.RSocial, @cd_Mda AS Moneda,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta'  FROM Empresa WHERE Empresa.Ruc = @RucEmp 

Set @Sql = '

select	
		  compra.FecMov AS FECHA_MOV
		, isnull(tipdoc.Descrip, '''') as TIP_DOC
		, isNull(compra.NroDoc	,0) as NUM_DOC
		, (case when GuiaXCompra.Cd_GR is not null then (''G '' + Guiaremision.NroSre + ''-'' + Guiaremision.NroGr) else '''' end		) as NUM_DE_GUIA
		, producto2.Nombre1 as NOM_PROD
		, isnull(compradet.Cant, 0) as CANTD
		, isnull(UnidadMedida.NCorto,'''') as UNID
		, ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') +'' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as NOM_PROV
		, compradet.Total as TOT
		--, FormaPC.Nombre FORM_PAGO
		, isnull(compra.CA01,'''') FORM_PAGO
		, Moneda.Simbolo as Moneda
		
			 from Compra 
			 left join TipDoc ON tipdoc.Cd_TD = compra.Cd_TD		
			 left join Proveedor2 ON Proveedor2.RucE = compra.RucE and proveedor2.Cd_Prv = compra.Cd_Prv	 
			 left join compradet on compradet.Cd_Com = compra.Cd_Com and compradet.RucE = compra.RucE
			 left join producto2 On producto2.Cd_Prod = compradet.Cd_Prod and producto2.RucE = compra.RucE
			 left join Prod_UM On Prod_UM.Cd_Prod = producto2.Cd_Prod and Prod_UM.RucE = compra.RucE and Prod_UM.ID_UMP = compradet.ID_UMP
			 left join UnidadMedida On UnidadMedida.Cd_UM = Prod_UM.Cd_UM
			 left join GuiaXCompra on guiaxcompra.RucE = compra.RucE and GuiaXCompra.Cd_Com = compradet.Cd_Com
			 left join GuiaRemision on GuiaRemision.RucE = Compra.RucE and GuiaRemision.cd_gr = guiaxcompra.cd_gr
			 left join FormaPC on FormaPC.Cd_FPC = compra.Cd_FPC
			 left join Moneda On Moneda.Cd_mda = Compra.cd_mda
			 where compra.RucE = '''+@RucEmp+'''    and compradet.Cd_Prod is not null 
				and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+' 23:59:29'' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''			 
				and proveedor2.Cd_Prv = (case '''+@cd_prv+''' when '''' then proveedor2.Cd_Prv else '''+@cd_prv+''' end)    
				and FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
				and producto2.cd_prod = (case '''+@Cd_Prod+''' when '''' then producto2.cd_prod else '''+@Cd_Prod+''' end)
				and Compra.Cd_mda = (case '''+@cd_Mda+''' when '''' then Compra.Cd_mda  else '''+@cd_Mda+''' end)    	
				--and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end)
				and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
				and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
'




exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd )

--Creado Por Rafael Gonzales 31/01/2013
-- exec  Rpt_CompraFacturaGuiaProducto   '20102028687', '01/01/2012' , '31/12/2013' , '10'			 ,'ASC'		,     NULL		,NULL,      NULl        , '03'			,0          ,''
-- EXEC  Rpt_CompraFacturaGuiaProducto   RUC___EMPRESA, FECHA__INICIO, FECHA__FINAL ,NUMCOL ,	TIP_ORD(ASC,DESC),  COD_PROV,  COD_PROD, CODIGO_FPC, CODIGO_MONEDA, DOC_PROVEEDOR, campo
										
	
GO

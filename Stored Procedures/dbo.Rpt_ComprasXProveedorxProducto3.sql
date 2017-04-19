SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ComprasXProveedorxProducto3] 

--DECLARE
									@RucEmp nvarchar(11)
								   ,@fecIni datetime
								   ,@fecFin datetime
						    	   ,@NroCol varchar(2) 
								   ,@TipOrd nvarchar(4)
								   ,@cd_prv char(7)
								   ,@Cd_Prod char(7)
								   ,@Est_Imp bit	
								   ,@Campo varchar(100)
								   ,@Cd_Mda nvarchar(2)
								   ,@Cd_FPC nvarchar(2)							   
								   ,@Cd_Alm varchar(20)


as

--Exec  Rpt_ComprasXProveedorxProducto   '20102028687', '01/01/2013' , '10/02/2013'  ,'1' ,'asc'   ,''  ,'' ,0,''   ,'03',    ''


--Set @RucEmp = '20102028687'
--Set @fecIni = '30/01/2000'
--Set @fecFin = '30/09/2013'
--Set @NroCol = '1'
--Set @TipOrd = 'asc'
--Set @cd_prv = ''
--Set @Cd_Prod = ''
--Set @Est_Imp = 0
--Set @Campo = ''
--Set @cd_Mda = '01'
--Set @Cd_FPC = ''
--Set @Cd_Alm = 'A01'

--SELECT cd.Cd_Alm,* from CompraDet cd WHERE cd.ruce = '20102028687' AND cd.Cd_Alm is NOT null
--select  * from almacen al where al.ruce = '20102028687'

declare @NMon varchar(50),
@Sql nvarchar(4000),
@Impt varchar(3)

/************************* VALIDACIONES *****************************/
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @cd_prv is null set @cd_prv = '' --Codigo Proveedor
If @Cd_Prod is null set @Cd_Prod = '' --Codigo Producto
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
If @Cd_Mda is null or @Cd_Mda = '03' or @Cd_Mda = '04' or @Cd_Mda = '05' set @Cd_Mda = '' --Codigo de Moneda
If @Cd_FPC is null  set @Cd_FPC = '' -- codigo forma pago
IF @Cd_Alm is null Set @Cd_Alm = '' -- codigo de almacen
/************************* VALIDACIONES *****************************/





SELECT  Empresa.Ruc, Empresa.RSocial,  'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta',  case @Est_Imp when 0 then 'COMPRAS LOCALES' when 1 then 'IMPORTACIÓN' end +' POR PROVEEDOR POR PRODUCTO'  as IC_Imp   FROM Empresa WHERE Empresa.Ruc = @RucEmp


Set @Sql =

'
select 			
			ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') + '' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as PROVEEDOR
				 ,producto2.Nombre1		  
				 , isnull(UnidadMedida.NCorto,'''') as Und				 
			 ,SUM(case Compra.prdo when ''01'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as ENERO
			 ,SUM(case Compra.prdo when ''02'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as FEBRERO			 
			 ,SUM(case Compra.prdo when ''03'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as MARZO			 
			 ,SUM(case Compra.prdo when ''04'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as ABRIL			 
			 ,SUM(case Compra.prdo when ''05'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as MAYO			 
			 ,SUM(case Compra.prdo when ''06'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as JUNIO			 
			 ,SUM(case Compra.prdo when ''07'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as JULIO			 
			 ,SUM(case Compra.prdo when ''08'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as AGOSTO		 
			 ,SUM(case Compra.prdo when ''09'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as SEPTIEMBRE
			 ,SUM(case Compra.prdo when ''10'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as OCTUBRE			 
			 ,SUM(case Compra.prdo when ''11'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as NOVIEMBRE			 
			 ,SUM(case Compra.prdo when ''12'' then case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end else 0.0 end) as DICIEMBRE
			 ,SUM(case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end) 	 as TOTAL_KGS				
				,isnull(al.nombre,''NINGUNO'') as NomAlmacen				  				
				 from producto2
				 --from compra				 
				 left join compradet on compradet.ruce = producto2.RucE and compradet.Cd_Prod = producto2.Cd_Prod
				 left join Compra on compra.RucE = compradet.RucE and compra.Cd_Com = compradet.Cd_Com 
				  left join inventario i on i.ruce = compra.ruce and i.cd_com = compra.cd_com
				left join almacen al on al.ruce = i.ruce and al.cd_alm = i.cd_alm			
				 left JOIN Proveedor2 ON Proveedor2.RucE  = Producto2.RucE	and Proveedor2.Cd_Prv = compra.Cd_Prv
				 left join Prod_UM on Prod_UM.Cd_Prod = compradet.Cd_Prod and Prod_UM.RucE = compradet.RucE and Prod_UM.ID_UMP = compradet.ID_UMP
				 left join UnidadMedida on UnidadMedida.Cd_UM = Prod_UM.Cd_UM
				 left join FormaPC ON FormaPC.Cd_FPC = Compra.Cd_FPC	
				 where  producto2.RucE = '''+@RucEmp+'''
				 and producto2.Cd_Prod is not null 				 
				 and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''		
				 and proveedor2.Cd_Prv = case '''+@cd_prv+''' when '''' then proveedor2.Cd_Prv else '''+@cd_prv+''' end
				 and Producto2.Cd_Prod = case '''+@Cd_Prod+''' when '''' then producto2.Cd_Prod else '''+@Cd_Prod+''' end
			     and compra.cd_td <> ''07''					
				and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
				 and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
				 and Compra.Cd_Mda =  (case '''+@Cd_Mda+''' when '''' then Compra.Cd_Mda else '''+@Cd_Mda+''' end) 
				 and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
				 and isnull(al.cd_alm,'''') =  case '''+@Cd_Alm+''' when '''' then isnull(al.cd_alm,'''') else '''+@Cd_Alm+''' end
				 group by  producto2.Cd_Prod,al.nombre, producto2.Nombre1, proveedor2.RSocial, proveedor2.ApPat, proveedor2.ApMat, proveedor2.Nom,UnidadMedida.NCorto
				 
				 
	'		 
	
	exec (@Sql + 'Order by ' + @NroCol + ' ' + @TipOrd )
	print (@Sql + 'Order by ' + @NroCol + ' ' + @TipOrd )
			 
--Creado Por Rafael Gonzales 31/01/2013
-- Exec  Rpt_ComprasXProveedorxProducto2   '20102028687', '01/01/1900' , '31/12/2078'     ,''                ,''            ,''	          ,''           ,0			, ''   ,'03',    ''
-- Exec	 Rpt_ComprasXProveedorxProducto   RUC___EMPRESA, FECHA_INICIO , FECHA_FINAL,    NUMCOL , 	 TIP_ORD(ASC,DESC) COD_PRODUCTO, COD_PROVEEDOR, DOC_PROVEEDOR , campo, cd_mda, cd_fpc



                      --ListaTipOrd.Items.Add("Producto");
                      --ListaTipOrd.Items.Add("Proveedor");
                      --ListaTipOrd.Items.Add("Unidad de Medida");
                      --ListaTipOrd.Items.Add("Mes de Enero");
                      --ListaTipOrd.Items.Add("Mes de Febrero");
                      --ListaTipOrd.Items.Add("Mes de Marzo");
                      --ListaTipOrd.Items.Add("Mes de Abril");
                      --ListaTipOrd.Items.Add("Mes de Mayo");
                      --ListaTipOrd.Items.Add("Mes de Junio");
                      --ListaTipOrd.Items.Add("Mes de Julio");
                      --ListaTipOrd.Items.Add("Mes de Agosto");
                      --ListaTipOrd.Items.Add("Mes de Septiembre");
                      --ListaTipOrd.Items.Add("Mes de Octubre");
                      --ListaTipOrd.Items.Add("Mes de Noviembre");
                      --ListaTipOrd.Items.Add("Mes de Diciembre");
                      --ListaTipOrd.Items.Add("Total");
                      --ListaTipOrd.Items.Add("Promedio");
                      --ListaTipOrd.Items.Add("Almacén");
GO

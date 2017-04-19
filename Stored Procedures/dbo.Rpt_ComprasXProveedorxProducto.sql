SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ComprasXProveedorxProducto] 
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


as



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
If @Cd_Mda is null or @Cd_Mda = '03' set @Cd_Mda = '' --Codigo de Moneda
If @Cd_FPC is null  set @Cd_FPC = '' -- codigo forma pago
/************************* VALIDACIONES *****************************/





SELECT  Empresa.Ruc, Empresa.RSocial,  'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta'  FROM Empresa WHERE Empresa.Ruc = @RucEmp


Set @Sql =

'
select 			  producto2.Cd_Prod
				 ,producto2.Nombre1
				 ,ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') + '' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as PROVEEDOR
				 ,UnidadMedida.NCorto as Und
	     		 ,SUM(case Compra.prdo when ''01'' then CompraDet.cant  else 0 end) as ENERO
        		 ,SUM(case Compra.prdo when ''02'' then CompraDet.cant else 0 end) as FEBRERO			 
			     ,SUM(case Compra.prdo when ''03'' then CompraDet.cant else 0 end) as MARZO			 
			     ,SUM(case Compra.prdo when ''04'' then CompraDet.cant else 0 end) as ABRIL			 
			     ,SUM(case Compra.prdo when ''05'' then CompraDet.cant else 0 end) as MAYO			 
			     ,SUM(case Compra.prdo when ''06'' then CompraDet.cant else 0 end) as JUNIO			 
			     ,SUM(case Compra.prdo when ''07'' then CompraDet.cant else 0 end) as JULIO			 
			     ,SUM(case Compra.prdo when ''08'' then CompraDet.cant else 0 end) as AGOSTO		 
			     ,SUM(case Compra.prdo when ''09'' then CompraDet.cant else 0 end) as SEPTIEMBRE
			     ,SUM(case Compra.prdo when ''10'' then CompraDet.cant else 0 end) as OCTUBRE			 
			     ,SUM(case Compra.prdo when ''11'' then CompraDet.cant else 0 end) as NOVIEMBRE			 
			     ,SUM(case Compra.prdo when ''12'' then CompraDet.cant else 0 end) as DICIEMBRE
			     ,SUM(CompraDet.cant) as TOTAL_KGS
				
				
				  				
				 from producto2				 
				 left join compradet on compradet.ruce = producto2.RucE and compradet.Cd_Prod = producto2.Cd_Prod
				 left join Compra on compra.RucE = compradet.RucE and compra.Cd_Com = compradet.Cd_Com 
				 left JOIN Proveedor2 ON Proveedor2.RucE  = Producto2.RucE	and Proveedor2.Cd_Prv = compra.Cd_Prv
				 left join Prod_UM on Prod_UM.Cd_Prod = producto2.Cd_Prod and Prod_UM.RucE = producto2.RucE
				 left join UnidadMedida on UnidadMedida.Cd_UM = Prod_UM.Cd_UM
				 left join FormaPC ON FormaPC.Cd_FPC = Compra.Cd_FPC	
				 where 
				 producto2.RucE = '''+@RucEmp+'''
				 and producto2.Cd_Prod is not null 
				 
				 and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+' 23:59:29'' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''		
				 and proveedor2.Cd_Prv = case '''+@cd_prv+''' when '''' then proveedor2.Cd_Prv else '''+@cd_prv+''' end
				 and Producto2.Cd_Prod = case '''+@Cd_Prod+''' when '''' then producto2.Cd_Prod else '''+@Cd_Prod+''' end
			     
				-- and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end)
				and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
				 and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
				 and Compra.Cd_Mda =  (case '''+@Cd_Mda+''' when '''' then Compra.Cd_Mda else '''+@Cd_Mda+''' end) 
				 and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
				 group by  producto2.Cd_Prod, producto2.Nombre1, proveedor2.RSocial, proveedor2.ApPat, proveedor2.ApMat, proveedor2.Nom,  UnidadMedida.NCorto-- , compradet.cant
				 
				 
	'		 
	
	exec (@Sql + 'Order by ' + @NroCol + ' ' + @TipOrd )
	print (@Sql + 'Order by ' + @NroCol + ' ' + @TipOrd )
			 
--Creado Por Rafael Gonzales 31/01/2013
-- Exec  Rpt_ComprasXProveedorxProducto   '20102028687', '01/01/1900' , '31/12/2078'     ,''                ,''            ,''	          ,''           ,0			, ''   ,'03',    ''
-- Exec	 Rpt_ComprasXProveedorxProducto   RUC___EMPRESA, FECHA_INICIO , FECHA_FINAL,    NUMCOL , 	 TIP_ORD(ASC,DESC) COD_PRODUCTO, COD_PROVEEDOR, DOC_PROVEEDOR , campo, cd_mda, cd_fpc
GO

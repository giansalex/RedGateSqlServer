SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure	[dbo].[Rpt_VentasXProdXClientes]
							@RucEmp nvarchar(11)
						   ,@fecIni datetime
						   ,@fecFin datetime
						   ,@NroCol varchar(2) 
					       ,@TipOrd nvarchar(4)
					       ,@Cd_Prod char(7)
					 	   ,@cd_clt char(10)
					 	   ,@cd_mda nvarchar(2)
					 	   


as

/************************* VALIDACIONES *****************************/
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @Cd_Prod is null set @Cd_Prod = '' -- Codigo de Producto
If @cd_clt is null set @cd_clt = '' --Codigo Cliente2
if @cd_Mda Is null set @cd_Mda = '' -- CODIGO DE MONEDA
/************************* VALIDACIONES *****************************/

Declare @Sql nvarchar(4000), @Prod char(7)




SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as FecCons,
  Producto2.Nombre1 as Nom_prod
  , (case UnidadMedida.NCorto when '' then '' when null then '' else UnidadMedida.NCorto end) as Unidades
		  FROM Empresa 
		  left join producto2 on Producto2.RucE = @RucEmp and producto2.cd_prod =  ( case @Cd_Prod when '' then ''  else @Cd_Prod end) and producto2.RucE = @RucEmp
		  left join Prod_UM on Prod_UM.Cd_Prod = producto2.Cd_Prod and Prod_UM.RucE = @RucEmp
		 left join UnidadMedida on UnidadMedida.Cd_UM = Prod_UM.Cd_UM 
		  WHERE Empresa.Ruc = @RucEmp 


Set @Sql = 
'
select		  Venta.Cd_Clt as Cd_Clt

			 ,ISNULL(Cliente2.RSocial,  isnull(Cliente2.ApPat, '''') +'' '' + isnull(Cliente2.ApMat,'''') + '' '' + isnull(Cliente2.Nom, '''') ) as Cliente			   	
			 ,SUM(case Venta.prdo when ''01'' then Ventadet.Cant else 0.0 end) as Cant_ENERO
			 ,SUM(case Venta.Prdo when ''02'' then Ventadet.Cant  else 0.0 end) as Cant_FEBRERO			 
			 ,SUM(case Venta.prdo when ''03'' then Ventadet.Cant else 0.0 end) as Cant_MARZO			 
			 ,SUM(case Venta.prdo when ''04'' then Ventadet.Cant else 0.0 end) as Cant_ABRIL			 
			 ,SUM(case Venta.prdo when ''05'' then Ventadet.Cant else 0.0 end) as Cant_MAYO			 
			 ,SUM(case Venta.prdo when ''06'' then Ventadet.Cant else 0.0 end) as Cant_JUNIO			 
			 ,SUM(case Venta.prdo when ''07'' then Ventadet.Cant else 0.0 end) as Cant_JULIO			 
			 ,SUM(case Venta.prdo when ''08'' then Ventadet.Cant else 0.0 end) as Cant_AGOSTO		 
			 ,SUM(case Venta.prdo when ''09'' then Ventadet.Cant else 0.0 end) as Cant_SEPTIEMBRE
			 ,SUM(case Venta.prdo when ''10'' then Ventadet.Cant else 0.0 end) as Cant_OCTUBRE			 
			 ,SUM(case Venta.prdo when ''11'' then Ventadet.Cant else 0.0 end) as Cant_NOVIEMBRE			 
			 ,SUM(case Venta.prdo when ''12'' then Ventadet.Cant else 0.0 end) as Cant_DICIEMBRE
			 ,SUM(Ventadet.Cant) as Total_Cant 
			 ,producto2.Cd_Prod as CodCoPrdSrv
			 ,producto2.Nombre1 as NomPrdSrv
			 ,UnidadMedida.NCorto as NCortoUM
			   from Venta 
			   left join Cliente2 on Cliente2.RucE = Venta.RucE and Cliente2.Cd_Clt = Venta.Cd_Clt
			   left join VentaDet On VentaDet.RucE = Venta.RucE and VentaDet.Cd_vta = venta.Cd_Vta
			   left join Producto2 on producto2.RucE = venta.RucE and producto2.Cd_Prod = ventadet.Cd_Prod
			   left join Prod_UM on Prod_UM.Cd_Prod = producto2.Cd_Prod and Prod_UM.RucE = '''+@RucEmp+'''
			   left join UnidadMedida on UnidadMedida.Cd_UM = Prod_UM.Cd_UM 
			   where
			    Venta.RucE = '''+@RucEmp+'''
			    				and Cliente2.Cd_Clt = (case '''+@cd_clt+''' when '''' then Cliente2.Cd_Clt else '''+@cd_clt+''' end)    
								and Venta.Cd_mda = (case '''+@cd_mda+''' when '''' then Venta.Cd_mda  else '''+@cd_mda+''' end)
								and Producto2.Cd_Prod = (case '''+@Cd_Prod+''' when '''' then producto2.Cd_Prod else '''+@cd_prod+''' end)    				    				
								and venta.FecMov between  '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''			 
								and isnull(venta.IB_Anulado,0) <>1
								and venta.cd_td <> ''07''
			   group by producto2.Cd_Prod, producto2.Nombre1,UnidadMedida.NCorto, venta.Cd_Clt, Cliente2.RSocial, cliente2.ApPat, Cliente2.ApMat, Cliente2.Nom
			   
			  

'

exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd )



--Creado Por Rafael Gonzales 08/02/2013
-- exec  Rpt_VentasXProdXClientes       '20102028687', '01/01/2000' , '31/12/2013'   , ''       	 ,''		    ,''    ,''	   ,'02'
-- EXEC  Rpt_VentasXProdXClientes       RUC___EMPRESA, FECHA__INICIO, FECHA__FINAL   ,NUMCOL,  TIP_ORD(ASC,DESC)  ,  COD_PROD,  COD_CLT,   COD_MDA
										



GO

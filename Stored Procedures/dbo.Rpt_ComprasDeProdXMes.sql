SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ComprasDeProdXMes] 
							@RucEmp nvarchar(11)
						   ,@fecIni datetime
						   ,@fecFin datetime
						   ,@NroCol varchar(2) 
					       ,@TipOrd nvarchar(4)
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
if @Cd_Prod IS NULL sET @Cd_Prod = '' --  CODIGO PRODUCTO
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
If @Cd_Mda is null or @Cd_Mda = '03' set @Cd_Mda = '' --Codigo de Moneda
If @Cd_FPC is null  set @Cd_FPC = '' -- codigo forma pago
/************************* VALIDACIONES *****************************/





SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta'  FROM Empresa WHERE Empresa.Ruc = @RucEmp


Set @Sql = 

'
select      Compradet.Cd_Prod, (
			select producto2.Nombre1 from Producto2 where producto2.Cd_Prod = compradet.Cd_Prod and producto2.RucE = compra.RucE and Producto2.Cd_Prod = (case '''+@Cd_Prod+''' when '''' then producto2.Cd_Prod else '''+@Cd_Prod+''' end)
			   ) as PRODUCTO
			, UnidadMedida.NCorto as UNID
			 ,SUM(case Compra.prdo when ''01'' then CompraDet.cant else 0.0 end) as ENERO
			 ,SUM(case Compra.prdo when ''02'' then CompraDet.cant else 0.0 end) as FEBRERO			 
			 ,SUM(case Compra.prdo when ''03'' then CompraDet.cant else 0.0 end) as MARZO			 
			 ,SUM(case Compra.prdo when ''04'' then CompraDet.cant else 0.0 end) as ABRIL			 
			 ,SUM(case Compra.prdo when ''05'' then CompraDet.cant else 0.0 end) as MAYO			 
			 ,SUM(case Compra.prdo when ''06'' then CompraDet.cant else 0.0 end) as JUNIO			 
			 ,SUM(case Compra.prdo when ''07'' then CompraDet.cant else 0.0 end) as JULIO			 
			 ,SUM(case Compra.prdo when ''08'' then CompraDet.cant else 0.0 end) as AGOSTO		 
			 ,SUM(case Compra.prdo when ''09'' then CompraDet.cant else 0.0 end) as SEPTIEMBRE
			 ,SUM(case Compra.prdo when ''10'' then CompraDet.cant else 0.0 end) as OCTUBRE			 
			 ,SUM(case Compra.prdo when ''11'' then CompraDet.cant else 0.0 end) as NOVIEMBRE			 
			 ,SUM(case Compra.prdo when ''12'' then CompraDet.cant else 0.0 end) as DICIEMBRE
			 ,SUM(CompraDet.cant) as TOTAL		 
							 from compra 
							 INNER JOIN CompraDet on CompraDet.RucE = Compra.RucE and CompraDet.Cd_Com = Compra.Cd_com
							 LEFT JOIN Prod_UM ON Prod_UM.Cd_Prod = CompraDet.Cd_Prod and prod_um.RucE = Compra.RucE and prod_um.ID_UMP = compradet.ID_UMP
							 LEFT JOIN UnidadMedida ON UnidadMedida.Cd_UM = Prod_UM.Cd_UM
							 LEFT JOIN Proveedor2 On Proveedor2.Cd_prv = compra.cd_prv and Proveedor2.RucE = Compra.RucE
							 where   
									Compra.RucE = '''+@RucEmp+'''
									and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''		
									 and Compradet.Cd_prod is not null
									 and CompraDet.Cd_prod = (case '''+@Cd_Prod+''' when '''' then Compradet.cd_prod else '''+@Cd_Prod+''' end)
									 
									-- and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end) 	 
									and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
									 
								and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)	
							 group by Compradet.Cd_Prod, compra.RucE, UnidadMedida.NCorto 
							 
'

exec (@sql + ' Order by ' + @NroCol + ' ' + @TipOrd )
PRINT (@sql + ' Order by ' + @NroCol + ' ' + @TipOrd )
							 
--Creado Por Rafael Gonzales 31/01/2013
-- Exec  Rpt_ComprasDeProdXMes           '11111111111'  ,'01/01/2012'  ,'31/12/2013'   ,''           ,''             ,''    ,     '0'       , ''   ,'03' ,   ''
-- EXEC  Rpt_CompraFacturaGuiaProducto   RUC___EMPRESA, FECHA__INICIO, FECHA__FINAL  ,NUMCOL ,	TIP_ORD(ASC,DESC),  COD_PROD, DOC_PROVEEDOR, campo, cd_mda, cd_fpc


GO

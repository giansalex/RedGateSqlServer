SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ComprasDeProdXMes3] 

--Declare
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
						   ,@IC_PrdSrv char(1)
						   ,@Cd_Alm varchar(20)
as


--Set @RucEmp = '20102028687'
--Set @fecIni = '01/01/2000'
--Set @fecFin = '31/03/2013'
--Set @NroCol = '1'
--Set @TipOrd = 'asc'
--Set @Cd_Prod = ''
--Set @Cd_FPC = ''
--Set @cd_Mda = '01'
--Set @Est_Imp = 0
--Set @Campo = ''
--Set @IC_PrdSrv = 'A'
--SET @Cd_Alm = ''

declare @NMon varchar(50),
@Sql nvarchar(4000),
@Sql1 nvarchar(4000),
@Sql2 nvarchar(4000),
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
If @Cd_Mda is null or @Cd_Mda = '03' or @Cd_Mda = '04' or @Cd_Mda = '05' set @Cd_Mda = '' --Codigo de Moneda
If @Cd_FPC is null  set @Cd_FPC = '' -- codigo forma pago
If @IC_PrdSrv is null or @IC_PrdSrv = '' set @IC_PrdSrv = 'A' -- Indicador Producto y Servicio
IF @Cd_Alm is null set @Cd_Alm = ''
/************************* VALIDACIONES *****************************/



--PRUEBA || COMPARACION DE DATOS REALES Y ACTUALES
--select cd.cant, cd.Total,c.Cd_Mda, c.fecmov, prv.NDoc, cd.Cd_Prod, cd.Cd_SRV, * from Compra c inner join CompraDet cd on cd.RucE = c.RucE and cd.Cd_Com = c.Cd_Com 
--	    left join Proveedor2 prv on prv.RucE = c.RucE and prv.Cd_Prv = c.Cd_Prv
--		where c.RucE = @RucEmp and c.FecMov between @fecIni and (@fecFin +' 23:59:29') and prv.NDoc  not like '%IMP%' and cd.Cd_Prod is not null
--		order by cd.Cd_Prod, c.Cd_Mda asc
--FIN DE PRUEBA
--Exec  Rpt_ComprasDeProdXMes           '20102028687'  ,'01/01/2013'  ,'10/02/2013'   ,'1'           ,'ASC'             ,''    ,     '0'       , ''   ,'03' ,   ''



SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta' , case @Impt when '0' then 'COMPRAS LOCALES' when '1' then  'IMPORTACIÓN' end  + ' DE PRODUCTOS POR MES'  as IC_Imp FROM Empresa WHERE Empresa.Ruc = @RucEmp


Set @Sql = 

'
select      case '''+@IC_PrdSrv+''' when ''S'' then ''-'' when ''P'' then isnull(producto2.codco1_,''-'' ) else isnull(producto2.codco1_, ''-'') end as CodPrdSrv,
			  case '''+@IC_PrdSrv+''' when  ''S'' then isnull(servicio2.Nombre,'''') when ''P'' then  isnull(producto2.Nombre1,'''') when ''A'' then isnull(producto2.nombre1, servicio2.nombre) end as PRODUCTO		
			, isnull(UnidadMedida.NCorto,'''') as UNID			 
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
			 ,SUM(case when isnull(compra.IB_Anulado,0) = 1 then 0.0 else CompraDet.cant end) as TOTAL		
			 ,isnull(al.nombre,''NINGUNO'') as NomAlmacen 
							 
'

Set @Sql1 =
'							 from compra 
							 INNER JOIN CompraDet on CompraDet.RucE = Compra.RucE and CompraDet.Cd_Com = Compra.Cd_com
						    left join inventario i on i.ruce = compra.ruce and i.cd_com = compra.cd_com
							left join almacen al on al.ruce = i.ruce and al.cd_alm = i.cd_alm
							-- left join almacen al on al.ruce = Compradet.ruce and al.cd_alm = Compradet.cd_alm
							 left join producto2 on producto2.ruce = compra.ruce and producto2.cd_prod = compradet.cd_prod
							 left join servicio2 on servicio2.ruce = compra.ruce and servicio2.cd_srv = compradet.cd_srv
							 LEFT JOIN Prod_UM ON Prod_UM.Cd_Prod = CompraDet.Cd_Prod and prod_um.RucE = Compra.RucE and prod_um.ID_UMP = compradet.ID_UMP
							 LEFT JOIN UnidadMedida ON UnidadMedida.Cd_UM = Prod_UM.Cd_UM
							 LEFT JOIN Proveedor2 On Proveedor2.Cd_prv = compra.cd_prv and Proveedor2.RucE = Compra.RucE
							  where   Compra.RucE = '''+@RucEmp+'''
							  and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''		
									 and CompraDet.Cd_prod = (case '''+@Cd_Prod+''' when '''' then Compradet.cd_prod else '''+@Cd_Prod+''' end)
'
Set @Sql2 = '															
								   and case when '''+@IC_PrdSrv+''' = ''S'' then '''' else (case  '''+@Cd_Prod+''' when '''' then '''' else compradet.cd_prod end) end = case when '''+@IC_PrdSrv+''' = ''S'' then '''' else  (case '''+@Cd_Prod+''' when '''' then '''' else '''+@Cd_Prod+''' end) end	 
									-- and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end) 	 
									and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
								and (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)	
								and  case '''+@IC_PrdSrv+''' when ''P'' then compradet.cd_prod when ''S'' then compradet.cd_srv else '''' end	 is not null
								and compra.cd_td <> ''07''					
								 and Compra.Cd_Mda =  (case '''+@Cd_Mda+''' when '''' then Compra.Cd_Mda else '''+@Cd_Mda+''' end)
								 and isnull(al.cd_alm,'''') =  case '''+@Cd_Alm+''' when '''' then isnull(al.cd_alm,'''') else '''+@Cd_Alm+''' end 								   			
							 group by producto2.codco1_,al.nombre,  compra.RucE, UnidadMedida.NCorto, producto2.nombre1, servicio2.nombre

'

exec (@sql + @Sql1+ @Sql2 + ' Order by ' + @NroCol + ' ' + @TipOrd )
PRINT (@sql + @Sql1 +@Sql2 + ' Order by ' + @NroCol + ' ' + @TipOrd )
							 
--Creado Por Rafael Gonzales 31/01/2013
-- Exec  Rpt_ComprasDeProdXMes2           '20102028687'  ,'01/02/2013'  ,'10/02/2013'   ,''           ,''             ,''    ,     '0'       , ''   ,'03' ,   ''   ,'A'
-- EXEC  Rpt_CompraFacturaGuiaProducto   RUC___EMPRESA, FECHA__INICIO, FECHA__FINAL  ,NUMCOL ,	TIP_ORD(ASC,DESC),  COD_PROD, DOC_PROVEEDOR, campo, cd_mda, cd_fpc


GO

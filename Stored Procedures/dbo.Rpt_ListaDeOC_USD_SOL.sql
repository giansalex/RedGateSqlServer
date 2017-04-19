SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE Procedure [dbo].[Rpt_ListaDeOC_USD_SOL]
							@RucEmp nvarchar(11)
						   ,@fecIni datetime
						   ,@fecFin datetime
						   ,@NroCol varchar(2) 
					       ,@TipOrd nvarchar(4)
					       ,@cd_prv char(7)
					       ,@Cd_FPC nvarchar(2) 
					       ,@Nro_OC varchar(50)
					       ,@Est_Imp bit
					       ,@Campo varchar(100)

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
if @Cd_FPC IS NULL SET @Cd_FPC = '' --FORMA DE PAGO
If @Nro_OC is NULL SET @Nro_OC = '' --NUMERO DE OC
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
/************************* VALIDACIONES *****************************/





SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta'  FROM Empresa WHERE Empresa.Ruc = @RucEmp


SET @Sql = '

select		OrdCompra.FecE as Fec_Cons
		   ,case  OrdCompra.NroOC  when Null then '''' else OrdCompra.NroOC end as Num_OC
		   ,ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') +'' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as Nom_prov
		   --,case FormaPC.Nombre when NULL then '''' else FormaPC.Nombre END as Forma_Pago
		   , isnull(compra.ca01, FormaPC.Nombre) as Forma_Pago
		   ,(case OrdCompra.Cd_Mda when ''01'' then OrdCompra.Total else 0 end)  as Soles 
		   ,(case OrdCompra.Cd_Mda when ''02'' then OrdCompra.Total else 0 end) as Dolares 		
			from OrdCompra
			left join Compra on Compra.RucE = OrdCompra.RucE and Compra.Cd_OC = OrdCompra.Cd_OC
			left join Proveedor2 on Proveedor2.RucE = OrdCompra.RucE and Compra.Cd_Prv = proveedor2.Cd_Prv	
			left join FormaPC on OrdCompra.Cd_FPC = OrdCompra.Cd_FPC	
			left join Moneda On OrdCompra.Cd_Mda = Moneda.Cd_Mda
			where 
			OrdCompra.RucE = '''+@RucEmp+'''
			and OrdCompra.FecE between '''+convert(varchar,@fecIni,103)+' 23:59:29'' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''
 			and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
 			and   Proveedor2.cd_prv =  (case '''+@cd_prv+''' when '''' then Proveedor2.cd_prv else '''+@cd_prv+''' end)
 			and   OrdCompra.NroOC =  (case '''+@Nro_OC+''' when '''' then OrdCompra.NroOC else '''+@Nro_OC+''' end)
												
			 and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)											
           -- and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end) 	 												
           and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
'							
												
exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd  )


--Creado Por Rafael Gonzales 08/02/2013
-- Exec  Rpt_ListaDeOC_USD_SOL  '20102028687', '1/02/2013' , '28/02/2013',     ''        ,'DESC'               ,''               ,''               ,''			,0         ,''
-- Exec  Rpt_ListaDeOC_USD_SOL  RUC___EMPRESA, FECHA_INICIO , FECHA__FINAL,   NUMCOL ,	TIP_ORD(ASC,DESC),  CODIGO_PROVEEDOR,  COD_FPC(FormaPago), NRO__OC, DOC_PROVEEDOR, campo
			    
			    
						
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE Procedure [dbo].[Rpt_ListaOC_General]


--Declare
							@RucEmp nvarchar(11)
						   ,@fecIni datetime
						   ,@fecFin datetime
						   ,@NroCol varchar(2) 
					       ,@TipOrd nvarchar(4)
					       ,@cd_prv char(7)
					       ,@Cd_FPC nvarchar(2) 
					       ,@Nro_OC varchar(50)					       
					       ,@Campo varchar(100)
						   ,@IC_PrdSrv char(1)
						   ,@EstOC varchar(100)
as




--Set @RucEmp = '20102028687'
--Set @fecIni = '01/03/2000'
--Set @fecFin = '02/04/2013'
--Set @NroCol = ''
--Set @TipOrd = ''
--Set @cd_prv = ''
--Set @Cd_FPC = ''
--Set @Nro_OC = ''
--Set @Campo  = ''
--Set @IC_PrdSrv = 'A'
--Set @EstOC = ''


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
If @Campo is null set @Campo = '' -- Validacion campo adicional 
If @IC_PrdSrv is null or @IC_PrdSrv = '' set @IC_PrdSrv = 'A' -- Indicador Producto y Servicio
/************************* VALIDACIONES *****************************/



SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta', 'Listado de ordenes de compra' as IC_Imp   FROM Empresa WHERE Empresa.Ruc = @RucEmp

SET @Sql = '

select   oc.FecE AS Fec_Cons
		,isnull(oc.NroOC, ''-'') as Num_OC
		,ISNULL(prv.RSocial,  isnull(prv.ApPat, '''') +'' '' + isnull(prv.ApMat,'''') + '' '' + isnull(prv.Nom, '''') ) as Nom_prov
		, UPPER(isnull(case when prv.NDoc like ''%IMP%'' then oc.Ca03 else oc.CA01 end,'''') ) as Forma_Pago
		,(case oc.cd_mda when ''01'' then oc.Total   else 0.0 end) as Soles
		,(case oc.cd_mda when ''02'' then oc.Total   else 0.0 end) as Dolares
	     ,EstadoOC.Descrip AS ESTD_OC
	     ,(case when prv.NDoc like ''%IMP%'' then ''IMPORTACIÓN'' else ''LOCAL'' end) as TipoCompra
from OrdCompra oc 
inner join OrdCompraDet ocdet on ocdet.RucE = oc.RucE and ocdet.Cd_OC = oc.Cd_OC
inner join Proveedor2 prv on prv.RucE = oc.RucE and prv.Cd_Prv = oc.Cd_Prv
left join pais pa on pa.cd_pais = prv.cd_pais
inner join FormaPC fpc on fpc.Cd_FPC = oc.Cd_FPC
LEFT JOIN EstadoOC ON EstadoOC.Id_EstOC = oc.Id_EstOC
where oc.RucE = '''+@RucEmp+''' and 
          oc.FecE between '''+convert(varchar,@fecIni,103)+''' and ( '''+convert(varchar,@fecFin,103)+'  23:59:29'' )
 			and   fpc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then fpc.cd_FPC else '''+@Cd_FPC+''' end)
 			and   prv.cd_prv =  (case '''+@cd_prv+''' when '''' then prv.cd_prv else '''+@cd_prv+''' end)
 			and   oc.NroOC =  (case '''+@Nro_OC+''' when '''' then oc.NroOC else '''+@Nro_OC+''' end)
			and   (case '''+@Campo+''' when '''' then '''' else  oc.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)											
         	and  case '''+@IC_PrdSrv+''' when ''P'' then ocdet.cd_prod when ''S'' then ocdet.cd_srv else '''' end	 is not null
         	and isnull(EstadoOC.Descrip, '''') = case '''+@EstOC+''' when '''' then isnull(EstadoOC.Descrip, '''') else '''+@EstOC+''' end
			group by oc.nrooc, prv.rsocial, prv.appat, prv.apmat, prv.nom,oc.total, oc.ca01, oc.ca02, oc.ca03, pa.nombre, fpc.nombre,   oc.cd_mda, prv.ndoc, oc.fece,EstadoOC.Descrip			
'							
												
exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd  )


GO

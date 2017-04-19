SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE Procedure [dbo].[Rpt_ListaDeOC_USD_SOL2]


--Declare
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
						   ,@IC_PrdSrv char(1)
as

--Set @RucEmp = '20102028687'
--Set @fecIni = '01/01/2000'
--Set @fecFin = '31/12/2013'
--Set @NroCol = ''
--Set @TipOrd = ''
--Set @cd_prv = ''
--Set @Cd_FPC = ''
--Set @Nro_OC = ''
--Set @Est_Imp= 1
--Set @Campo  = ''
--Set @IC_PrdSrv = 'S'



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
If @IC_PrdSrv is null or @IC_PrdSrv = '' set @IC_PrdSrv = 'A' -- Indicador Producto y Servicio
/************************* VALIDACIONES *****************************/
--SELECT * FROM OrdCompradet ocdet where ocdet.ruce = @rucemp and OCDET.Cd_SRV is not null
--select * from OrdCompra oc where oc.RucE = @RucEmp and oc.NroOC = 'OC00000071'

--select   oc.FecE

--		,isnull(oc.NroOC, '-') as Num_OC
--		,ISNULL(prv.RSocial,  isnull(prv.ApPat, '') +' ' + isnull(prv.ApMat,'') + ' ' + isnull(prv.Nom, '') ) as Nom_prov
--		,isnull(oc.CA01, fpc.Nombre) as Forma_Pago
--		,(case oc.cd_mda when '01' then oc.Total   else 0.0 end) as Soles
--		,(case oc.cd_mda when '02' then oc.Total   else 0.0 end) as Dolares
--		, prv.NDoc
--from OrdCompra oc 
--inner join OrdCompraDet ocdet on ocdet.RucE = oc.RucE and ocdet.Cd_OC = oc.Cd_OC
--inner join Proveedor2 prv on prv.RucE = oc.RucE and prv.Cd_Prv = oc.Cd_Prv
--inner join FormaPC fpc on fpc.Cd_FPC = oc.Cd_FPC
--where oc.RucE = @RucEmp and oc.FecE between convert(varchar,@fecIni,103) and ( convert(varchar,@fecFin,103) + ' 23:59:29' )

-- 			and   fpc.CD_FPC =  (case @Cd_FPC when '' then fpc.cd_FPC else @Cd_FPC end)
-- 			and   prv.cd_prv =  (case @cd_prv when '' then prv.cd_prv else @cd_prv end)
-- 			and   oc.NroOC =  (case @Nro_OC when '' then oc.NroOC else @Nro_OC end)
--			and   (case @Campo when '' then '' else  oc.ca01 end) = (case @Campo when '' then '' else @Campo end)											
--            and prv.NDoc like (case @Impt when '0' then '%%' else '%IMP%' end) and  (case when @Impt = '0' then prv.NDoc else '1' end) not like (case when @Impt = '0' then '%IMP%' else '2' end)
--            and  case @IC_PrdSrv when 'P' then ocdet.cd_prod when 'S' then ocdet.cd_srv else '' end	 is not null
--group by oc.NroOC, prv.RSocial, prv.ApPat, prv.ApMat, prv.Nom, oc.CA01, oc.Total, oc.Cd_Mda, prv.NDoc, oc.FecE,  fpc.Nombre

SELECT  Empresa.Ruc, Empresa.RSocial,   'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta' ,  'LISTADO DE ORDENES DE COMPRA '+ case @Impt when '0' then 'LOCALES' when '1' then 'DE IMPORTACIÓN' end   as IC_Imp  FROM Empresa WHERE Empresa.Ruc = @RucEmp
--select * from OrdCompra oc where oc.RucE = '20102028687' and oc.Cd_OC = 'OC00000004'

SET @Sql = '

select   oc.FecE AS Fec_Cons
		,isnull(oc.NroOC, ''-'') as Num_OC
		,ISNULL(prv.RSocial,  isnull(prv.ApPat, '''') +'' '' + isnull(prv.ApMat,'''') + '' '' + isnull(prv.Nom, '''') ) as Nom_prov
		,UPPER(isnull(case '''+@Impt+''' when ''0'' then oc.CA01 when ''1'' then oc.CA03 end, '''')) as Forma_Pago
		,(case oc.cd_mda when ''01'' then oc.Total   else 0.0 end) as Soles
		,(case oc.cd_mda when ''02'' then oc.Total   else 0.0 end) as Dolares
		, prv.NDoc
		 ,isnull(oc.CA02, ''-'') as INCOTERM
	     ,isnull(pa.Nombre, ''-'') as PAIS
from OrdCompra oc 
inner join OrdCompraDet ocdet on ocdet.RucE = oc.RucE and ocdet.Cd_OC = oc.Cd_OC
inner join Proveedor2 prv on prv.RucE = oc.RucE and prv.Cd_Prv = oc.Cd_Prv
left join pais pa on pa.cd_pais = prv.cd_pais
inner join FormaPC fpc on fpc.Cd_FPC = oc.Cd_FPC
where oc.RucE = '''+@RucEmp+''' and 
          oc.FecE between '''+convert(varchar,@fecIni,103)+''' and ( '''+convert(varchar,@fecFin,103)+'  23:59:29'' )

 			and   fpc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then fpc.cd_FPC else '''+@Cd_FPC+''' end)
 			and   prv.cd_prv =  (case '''+@cd_prv+''' when '''' then prv.cd_prv else '''+@cd_prv+''' end)
 			and   oc.NroOC =  (case '''+@Nro_OC+''' when '''' then oc.NroOC else '''+@Nro_OC+''' end)
			and   (case '''+@Campo+''' when '''' then '''' else  oc.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)											
            and prv.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then prv.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
			and  case '''+@IC_PrdSrv+''' when ''P'' then ocdet.cd_prod when ''S'' then ocdet.cd_srv else '''' end	 is not null
			group by oc.nrooc, prv.rsocial, prv.appat, prv.apmat, prv.nom,oc.total, oc.ca01, oc.ca02, oc.ca03, pa.nombre, fpc.nombre,   oc.cd_mda, prv.ndoc, oc.fece
			
'							
												
exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd  )


--Creado Por Rafael Gonzales 08/02/2013
-- Exec  Rpt_ListaDeOC_USD_SOL2  '20102028687', '1/02/2000' , '28/02/2013',     ''        ,'DESC'               ,''               ,''               ,'OC00000004'			,0        ,'', 'A'
-- Exec  Rpt_ListaDeOC_USD_SOL  RUC___EMPRESA, FECHA_INICIO , FECHA__FINAL,   NUMCOL ,	TIP_ORD(ASC,DESC),  CODIGO_PROVEEDOR,  COD_FPC(FormaPago), NRO__OC, DOC_PROVEEDOR, campo
			    
			    
			
		
			

/*
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
			and OrdCompra.FecE between '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''
 			and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
 			and   Proveedor2.cd_prv =  (case '''+@cd_prv+''' when '''' then Proveedor2.cd_prv else '''+@cd_prv+''' end)
 			and   OrdCompra.NroOC =  (case '''+@Nro_OC+''' when '''' then OrdCompra.NroOC else '''+@Nro_OC+''' end)
												
			 and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)											
           -- and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end) 	 												
           and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
           
           
 */
GO

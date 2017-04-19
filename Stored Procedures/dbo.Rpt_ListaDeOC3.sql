SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	CREATE PROCEDURE [dbo].[Rpt_ListaDeOC3]

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
								   ,@Cd_mda nvarchar(2)
AS

--Set @RucEmp = '20102028687'
--Set @fecIni = '01/01/2000'
--Set @fecFin = '31/12/2013'
--Set @NroCol = '1'
--Set @TipOrd = 'ASC'
--Set @cd_prv = ''
--Set @Cd_FPC = ''
--Set @Nro_OC = ''
--Set @Cd_mda = '02'
--Set @Est_Imp= 0
--Set @Campo  = ''
--Set @IC_PrdSrv = 'A'


DECLARE @Sql nvarchar(4000), @NMon varchar(50), @IC_Mda nvarchar(2), @Impt varchar(3)
/************************* VALIDACIONES *****************************/
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @cd_prv is null set @cd_prv = '' --Codigo Proveedor
if @Cd_FPC IS NULL SET @Cd_FPC = '' --FORMA DE PAGO
If @Nro_OC is NULL SET @Nro_OC = '' --NUMERO DE OC
If @Cd_mda is null begin Set @Cd_mda = '' Set @IC_Mda = '' end --CODIGO DE MONEDA
	IF @Cd_Mda = '04' BEGIN set @IC_Mda = '04'  set @Cd_Mda = '' end
	IF @Cd_Mda = '05' BEGIN set @IC_Mda = '05'  set @Cd_Mda = '' end
    IF @Cd_Mda = '02' set @IC_Mda = ''
    If @Cd_Mda = '01' set @IC_Mda = ''
    If @Cd_Mda = '03' set @IC_Mda = ''
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
If @IC_PrdSrv is null or @IC_PrdSrv = '' set @IC_PrdSrv = 'A' -- Indicador Producto y Servicio
/************************* VALIDACIONES *****************************/

            --LEYENDA DE MONEDAS
            -- 1:SOLES
             -- 2:DOLARES
             -- 3:AMBAS MONEDAS SIN INCLUSIÓN
             -- 4:SOLES INCLUYENDO DOLARES (TRANSFORMADOS)                
            -- 5:DOLARES INCLUYENDO SOLES (TRANSFORMADOS)


Set @NMon = (Select moneda.Nombre from Moneda where moneda.Cd_Mda = @Cd_Mda)
SELECT  Empresa.Ruc, Empresa.RSocial,  upper(isnull(@NMon,'')) as 'Moneda', 'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta',  case @Impt when '0' then 'LISTA DE ORDENES DE COMPRA LOCALES' when '1' then  'LISTA DE ORDENES DE IMPORTACIÓN' end +case   WHEN @Cd_mda =  '01' or @IC_Mda = '04' THEN ' EN SOLES' WHEN @Cd_mda =  '02' OR @IC_Mda =  '05' THEN ' EN DÓLARES' ELSE '' END  as IC_Imp  FROM Empresa WHERE Empresa.Ruc = @RucEmp


SET @Sql =

'
SELECT			OrdCompra.NroOC AS NRO_OC			   
			   ,ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') + '' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as PROVEEDOR
			   ,OrdCompra.FecE AS FEC_REG
			   ,OrdCompra.Cd_Mda AS CD_MDA
			   ,(case '''+@IC_Mda+''' when ''04'' then (case OrdCompra.cd_mda when ''02'' then ''*S/.''  else m.Simbolo end) when ''05'' then (case OrdCompra.cd_mda when ''01'' then ''*US$'' else m.Simbolo end) else m.Simbolo end) as Simbolo
			   ,(case '''+@IC_Mda+''' when ''04'' then (case OrdCompra.Cd_Mda when ''02'' then OrdCompra.Total * OrdCompra.CamMda else OrdCompra.Total end) when ''05'' then (case OrdCompra.Cd_mda when ''01'' then OrdCompra.Total /OrdCompra.CamMda else OrdCompra.Total end) else  OrdCompra.Total end) AS TOTAL
			   ,EstadoOC.Descrip AS ESTD_OC
			   ,isnull(case '''+@Impt+''' when ''0'' then OrdCompra.CA01 when ''1'' then OrdCompra.CA03 end,'''') as COND_PAGO
			   
			    From OrdCompra	
			    inner join OrdCompraDet ocdet on ocdet.RucE = OrdCompra.RucE and ocdet.Cd_OC = OrdCompra.Cd_OC	
			    LEFT JOIN Proveedor2 ON Proveedor2.RucE = OrdCompra.RucE and Proveedor2.Cd_Prv = OrdCompra.Cd_Prv    
			    LEFT JOIN FormaPC ON FormaPC.Cd_FPC = OrdCompra.Cd_FPC
			    LEFT JOIN EstadoOC ON EstadoOC.Id_EstOC = OrdCompra.Id_EstOC
			    Left join Moneda m On m.Cd_mda = OrdCompra.cd_mda
			    where 
			    OrdCompra.RucE = '''+@RucEmp+'''
			    and OrdCompra.FecE between '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''
 				and  FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
 				and proveedor2.cd_prv = (case '''+@cd_prv+''' when '''' then proveedor2.cd_prv else '''+@cd_prv+''' end)
			    and OrdCompra.NroOC = (case '''+@Nro_OC+''' when '''' then OrdCompra.NroOC else '''+@Nro_OC+''' end)
			    and OrdCompra.Cd_Mda = (case '''+@Cd_mda+''' when '''' then OrdCompra.Cd_Mda else '''+@Cd_mda+''' end)
		
				and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
				and   (case '''+@Campo+''' when '''' then '''' else  OrdCompra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
				
				and  case '''+@IC_PrdSrv+''' when ''P'' then ocdet.cd_prod when ''S'' then ocdet.cd_srv else '''' end	 is not null
				group by ordcompra.nrooc, proveedor2.rsocial, proveedor2.appat, proveedor2.apmat, proveedor2.nom,
				ordcompra.fece, ordcompra.cd_mda, m.simbolo, ordcompra.total, estadooc.descrip, ordcompra.ca01, ordcompra.ca03,OrdCompra.CamMda
				
'

exec (@sql + 'Order by ' + @NroCol + '  ' + @TipOrd  )

			    
			
		
			
--Creado Por Rafael Gonzales 04/02/2013
-- Exec  Rpt_ListaDeOC2  '20102028687', '01/01/2011' , '31/12/2013',     '01'        ,'DESC'               ,''                 ,''             ,'',      ''			   ,1          , ''             ,'P'
-- Exec  Rpt_ListaDeOC  RUC___EMPRESA, FECHA_INICIO , FECHA__FINAL,   NUMCOL ,	TIP_ORD(ASC,DESC),  CODIGO_PROVEED  OR,  COD_FPC(FormaPago), NRO__OC, COD_MONEDA,  DOC_PROVEEDOR , campo adicional			
			    
			    
			    
			    


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE  [dbo].[Rpt_CompraXProveedor3]
--Declare
	 @RucEmp nvarchar(11)
	,@fecIni datetime
	,@fecFin datetime
	,@NroCol varchar(2) 
    ,@TipOrd nvarchar(4)		
	,@cd_prv char(7)
	,@Cd_Mda nvarchar(2)
    ,@NumSerie varchar(5)
	,@NumDoc varchar(15)
	,@Est_Imp bit
	,@Cd_FPC nvarchar(2)
	,@Campo varchar(100)
	,@IC_PrdSrv char(1)

as


--Set @RucEmp = '20102028687'
--Set @fecIni = '26/02/2000'
--Set @fecFin = '28/02/2013'
--Set @NroCol = '1'
--Set @TipOrd = 'ASC'
--Set @cd_prv = ''
--Set @Cd_mda = '01'
--Set @NumSerie = ''
--Set @NumDoc = ''
--Set @Est_Imp= 1
--Set @Cd_FPC = ''
--Set @Campo  = ''
--Set @IC_PrdSrv = 'A'


declare @NMon varchar(50),
@Sql nvarchar(4000),
@Sql1 nvarchar(4000),
@IC_Mda nvarchar(2),
@Impt nvarchar(3)

/************************* VALIDACIONES *****************************/
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @cd_prv is null set @cd_prv = '' --Codigo Proveedor
If @Cd_Mda is null or @Cd_Mda = '03' BEGIN set @Cd_Mda = '' set @IC_Mda = '' END--Codigo de Moneda
	IF @Cd_Mda = '04' BEGIN set @IC_Mda = '04'  set @Cd_Mda = '' end
	IF @Cd_Mda = '05' BEGIN set @IC_Mda = '05'  set @Cd_Mda = '' end
    IF @Cd_Mda = '02' set @IC_Mda = ''
    If @Cd_Mda = '01' set @IC_Mda = ''
--If @Est_Imp = 0 set @Impt ='' else set @Impt = 'IMP' --Importacion
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion Modificado
If @Campo is null set @Campo = '' -- Validacion campo adicional 
If @Cd_FPC is null  set @Cd_FPC = '' -- codigo forma pago
If @IC_PrdSrv is null or @IC_PrdSrv = '' set @IC_PrdSrv = 'A' -- Indicador Producto y Servicio
/************************* VALIDACIONES *****************************/ 

            --LEYENDA DE MONEDAS
            -- 1:SOLES
             -- 2:DOLARES
             -- 3:AMBAS MONEDAS SIN INCLUSIÓN
             -- 4:SOLES INCLUYENDO DOLARES (TRANSFORMADOS)                
            -- 5:DOLARES INCLUYENDO SOLES (TRANSFORMADOS)
            


Set @NMon = (Select moneda.Nombre from moneda where moneda.Cd_Mda = @Cd_Mda)
SELECT  Empresa.Ruc, Empresa.RSocial,  upper(isnull(@NMon,'')) as 'Moneda', 'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta',  
case @Impt when '0' then 'COMPRAS POR PROVEEDOR LOCALES' when '1' then  'IMPORTACIONES POR PROVEEDOR'  end + 
case   WHEN @Cd_Mda =  '01' or @IC_Mda = '04' THEN 
(CASE WHEN ((@RucEmp = '20102028687') or  (@RucEmp = '20101588930') or  (@RucEmp = '20544359674')) and @Est_Imp = 1 THEN '' ELSE ' EN SOLES' END) 
       WHEN @Cd_mda =  '02' OR @IC_Mda =  '05' THEN ' EN DÓLARES' ELSE '' END   as IC_Imp  FROM Empresa WHERE Empresa.Ruc = @RucEmp


Set @Sql = '
Select  ISNULL(Proveedor2.RSocial, ISNULL(Proveedor2.ApPat,'''') + '' '' + ISNULL(Proveedor2.ApMat,'''') + '' '' + ISNULL(Proveedor2.Nom,'''') )  as PROVEEDOR -- RAZON SOCIAL O NOMBRE COMPLETO
		,Compra.FecMov as Fech_Mov
		,tipdoc.NCorto + '' / '' + Compra.NroSre + ''-'' + Compra.NroDoc as Comprobante
	
		, case '''+@Impt+''' when ''0'' then ISNULL(Producto2.CodCo1_ , isnull(Servicio2.Cd_Srv,''''))   when ''1'' then isnull(compra.cd_oc, ''-'')  end as Codigo
   
		,ISNULL(Producto2.Nombre1, Servicio2.Nombre) as Descripcion
		,ISNULL(UnidadMedida.NCorto, '''') as U_M
		,case when isnull(compra.ib_anulado,0) = 1 then 0.0 else (   isnull(compraDet.Cant,0.0) ) end as Cantidad
		,case when isnull(compra.ib_anulado,0) = 1 then 0.0 else (  case '''+@IC_Mda+''' when ''04'' then  ( case Compra.cd_mda when ''02'' then  CompraDet.IMP * Compra.CamMda else CompraDet.IMP end ) when ''05'' then ( case Compra.cd_mda when ''01'' then  (CompraDet.IMP / Compra.CamMda ) else CompraDet.IMP end ) else isnull(CompraDet.IMP,0.0)  end) end as Prc_Unit
		,case when isnull(compra.ib_anulado,0) = 1 then 0.0 else (  case '''+@IC_Mda+''' when ''04'' then  ( case Compra.cd_mda when ''02'' then  isnull(CompraDet.DsctoI,0.0) * Compra.CamMda else isnull(CompraDet.DsctoI,0.0) end ) when ''05'' then ( case Compra.cd_mda when ''01'' then  (isnull(CompraDet.DsctoI,0.0) / Compra.CamMda) else isnull(CompraDet.DsctoI,0.0) end ) else ISNULL(Compradet.DsctoI,0.0) end)  end as Desc_Imp
		,case when isnull(compra.ib_anulado,0) = 1 then 0.0 else ISNULL(CompraDet.DsctoP, 0.0) end as Desc_Porc
		,case when isnull(compra.ib_anulado,0) = 1 then 0.0 else (case '''+@IC_Mda+''' when ''04'' then (case compra.cd_mda when ''02'' then  compraDet.IMPTot*Compra.CamMda else CompraDet.IMPTot end) when ''05'' then (case compra.cd_mda when ''01'' then  (compraDet.IMPTot/Compra.CamMda) else CompraDet.IMPTot end)  else isnull(compraDet.IMPTot,0.0) end) end  as Sub_Tot	
		,case '''+@IC_Mda+''' when ''04'' then (case Compra.cd_mda when ''02'' then ''*S/.''  else moneda.simbolo end) when ''05'' then (case Compra.cd_mda when ''01'' then ''*US$''  else moneda.simbolo end)  else Moneda.Simbolo end as Moneda	
		,isnull(oc.CA02, ''-'') as INCOTERM
		
		, isnull(i.fecmov,'''') as FechaInAlm
		,isnull(oc.fece,'''') as FechaOC
		,isnull(oc.NroOC, ''-'') as Num_OC 
		,'''+@Impt+''' as IB_Imp
		
		 from proveedor2		   
		INNER JOIN Compra ON Compra.Cd_Prv = Proveedor2.Cd_Prv and Compra.RucE = Proveedor2.RucE
		left join OrdCompra oc on oc.ruce = proveedor2.ruce and oc.cd_oc = compra.cd_oc
		INNER JOIN CompraDet ON CompraDet.Cd_Com = Compra.Cd_Com and CompraDet.RucE = Compra.RucE
		left join inventario i on i.ruce = compra.ruce and i.cd_com = compra.cd_com
		LEFT JOIN Prod_UM ON Prod_UM.Cd_Prod = CompraDet.Cd_Prod and Prod_Um.ID_UMP = CompraDet.ID_UMP and Prod_UM.RucE = CompraDet.RucE
		LEFT JOIN UnidadMedida ON UnidadMedida.Cd_UM = Prod_UM.Cd_UM
		LEFT JOIN tipdoc  On tipdoc.Cd_TD = compra.Cd_td
		LEFT JOIN Producto2 ON Producto2.Cd_Prod = CompraDet.Cd_Prod and Producto2.RucE = CompraDet.RucE
		LEFT JOIN Servicio2 ON Servicio2.Cd_Srv = CompraDet.Cd_SRV and Servicio2.RucE = Proveedor2.RucE		
		Left join Moneda On Moneda.Cd_mda = compra.cd_mda
		left join FormaPC ON FormaPC.Cd_FPC = Compra.Cd_FPC	


'        

SET @Sql1 =
'
        where 			
        
        	proveedor2.Cd_Prv = (case '''+@cd_prv+''' when '''' then proveedor2.Cd_Prv else '''+@cd_prv+''' end)    and
			proveedor2.RucE = '''+@RucEmp+'''	and Compra.FecMov between  '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''		
			and Compra.Cd_Mda =  (case '''+@Cd_Mda+''' when '''' then Compra.Cd_Mda else '''+@Cd_Mda+''' end) 
			and Compra.NroSre =  isnull( (case '''+@NumSerie+''' when '''' then Compra.NroSre else '''+@NumSerie+''' end) , Compra.NroSre)
			and compra.NroDoc = isnull( (case '''+@NumDoc+''' when '''' then compra.NroDoc else '''+@NumDoc+''' end) , compra.NroDoc) 			
			--and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end)
			and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
			and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
		and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
			and compra.cd_td <> ''07''	and  (case '''+@IC_PrdSrv+''' when ''P'' then CompraDet.cd_prod when ''S'' then CompraDet.cd_srv else '''' end)	 is not null			
			


'
--SET @Sql1 = '
--			group by compradet.imptot, Proveedor2.Rsocial, proveedor2.ApMat, proveedor2.ApPat, proveedor2.Nom, compra.FecMov, tipdoc.NCorto, Compra.NroSre,  Compra.NroDoc,
--			 compra.cd_oc,Producto2.CodCo1_ , Servicio2.Cd_Srv, producto2.Nombre1, servicio2.Nombre, UnidadMedida.NCorto, compradet.Cant, compradet.IMP, compradet.DsctoI, compradet.DsctoP , Moneda.Simbolo , compra.ib_anulado
--			  , oc.ca02,Compra.CamMda, compra.cd_mda

--'



exec (@Sql+ @Sql1 +' Order by ' + @NroCol + ' ' + @TipOrd )
print (@Sql + @Sql1 + ' Order by ' + @NroCol + ' ' + @TipOrd )

        
        
--Creado Por Rafael Gonzales 29/01/2013
-- exec  rpt_CompraXProveedor2   '20102028687',  '01/01/2000'   ,'31/12/2013'    ,NULL             ,'DESC'               , ''          , '01'          ,''            , ''             , true            ,'' , '' ,'A'
-- Exec rpt_CompraXProveedor    RUC__EMPRESA   , FECHA_INICIO,   FECHA_FIN,    NUMCOL , 	 TIP_ORD(ASC,DESC),  CODIGO_PROVEEDOR, CODIGO_MONEDA, NUMERO_SERIE, NUMERO DOCUMENTO,, DOC_PROVEEDOR, CD_FPC, CAMPO




GO

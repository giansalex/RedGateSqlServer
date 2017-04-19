SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_ComprasAProveedor] 
--Declare
								@RucEmp nvarchar(11)
								,@fecIni datetime
								,@fecFin datetime
								,@NroCol varchar(2) 
								,@TipOrd nvarchar(4)								
								,@cd_prv char(7)
								,@Cd_FPC nvarchar(2) 
								,@Est_Imp bit
								,@Campo varchar(100)

--Set @RucEmp = '20102028687'
--Set @fecIni = '20/12/2000'
--Set @fecFin = '31/12/2013 23:59:29'
--Set @NroCol = '1'
--Set @TipOrd = 'asc'
--Set @cd_prv = ''
--Set @Cd_FPC = ''
--Set @Est_Imp = 1
--Set @Campo = ''


--select C.IB_Anulado,  P.Cd_Prv, P.RSocial, * from Compra c inner join proveedor2 p on p.RucE = c.RucE and p.Cd_Prv = c.Cd_Prv where c.RucE = @RucEmp and c.FecMov between  @fecIni and @fecFin and p.NDoc like '%IMP%'
AS


declare @NMon varchar(50),
@Sql nvarchar(4000),
@Impt varchar(3)

/************************* VALIDACIONES *****************************/
if @Cd_FPC IS NULL SET @Cd_FPC = '' --FORMA DE PAGO
If @RucEmp is null set @RucEmp = '' -- Ruc Empresa
If @fecFin is null or @fecFin = '' set @fecFin = '31/12/2078' --Fecha Final
If @fecIni is null or @fecIni = '' set @fecIni = '01/01/1900' --Fecha Inicio
If @NroCol is null or @NroCol = '' set @NroCol = '01' -- NUMERO DE COLUMNA
If @TipOrd is null or @TipOrd = '' set @TipOrd = 'ASC' -- Tipo de Orden
If @cd_prv is null set @cd_prv = '' --Codigo Proveedor
If @Est_Imp = 0 set @Impt ='0' else set @Impt = '1' --Importacion
--If @Est_Imp = 0 set @Impt = '' else set @Impt = 'IMP' 
If @Campo is null set @Campo = '' -- Campo Adicional
/************************* VALIDACIONES *****************************/

SELECT  Empresa.Ruc, Empresa.RSocial,  'Desde el ' + convert(varchar,@fecIni,103)+ ' hasta el ' + convert(varchar,@fecFin,103)   as 'Fecha Consulta'  FROM Empresa WHERE Empresa.Ruc = @RucEmp

set @sql = '

select
	(Select Moneda.Nombre from Moneda where Moneda.Cd_Mda = Compra.cd_mda)	as MONEDA 
	--,compra.ib_anulado
	,ISNULL(Proveedor2.RSocial,  isnull(Proveedor2.ApPat, '''') + '' '' + isnull(Proveedor2.ApMat,'''') + '' '' + isnull(Proveedor2.Nom, '''') ) as PROVEEDOR
	,isnull(compra.CA01,FormaPC.Nombre) as  CONDICION_PAGO
	
	--, FormaPC.Nombre as CONDICION_PAGO
	,  sum(case compra.Prdo when ''01'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end  else 0 end) as ENERO
	, sum(case compra.Prdo when ''02'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as FEBRERO
	, sum(case compra.Prdo when ''03'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as MARZO
	, sum(case compra.Prdo when ''04'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as ABRIL
	, sum(case compra.Prdo when ''05'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as MAYO
	, sum(case compra.Prdo when ''06'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as JUNIO
	, sum(case compra.Prdo when ''07'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as JULIO
	, sum(case compra.Prdo when ''08'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as AGOSTO
	, sum(case compra.Prdo when ''09'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as SEPTIEMBRE
	, sum(case compra.Prdo when ''10'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as OCTUBRE
	, sum(case compra.Prdo when ''11'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as NOVIEMBRE
	, sum(case compra.Prdo when ''12'' then case when isnull(compra.IB_anulado,0) = 1 then 0.0 else isnull(compra.Total,0) end   else 0 end) as DICIEMBRE		
	
	, sum ( case compra.cd_prv when  proveedor2.Cd_Prv then  isnull(compra.Total,0) else 0 end ) as TOTAL
	from Compra
		left Join Proveedor2 ON Proveedor2.RucE = compra.RucE and proveedor2.Cd_Prv = compra.cd_prv 
		inner join FormaPC ON FormaPC.Cd_FPC = Compra.Cd_FPC and FormaPC.Estado = 1
		
 	where Compra.RucE = '''+@RucEmp+'''		and Compra.FecMov between '''+convert(varchar,@fecIni,103)+''' and  '''+convert(varchar,@fecFin,103)+' 23:59:29''
 			and   FormaPc.CD_FPC =  (case '''+@Cd_FPC+''' when '''' then FormaPc.cd_FPC else '''+@Cd_FPC+''' end)
 			and proveedor2.cd_prv = (case '''+@cd_prv+''' when '''' then proveedor2.cd_prv else '''+@cd_prv+''' end)
 			and   (case '''+@Campo+''' when '''' then '''' else  compra.ca01 end) = (case '''+@Campo+''' when '''' then '''' else '''+@Campo+''' end)
 			
 		--	and proveedor2.Ndoc like (case '''+@Impt+''' when '''' then proveedor2.Ndoc else ''%'+@Impt+'%'' end)
 			and proveedor2.NDoc like (case '''+@Impt+''' when ''0'' then ''%%'' else ''%IMP%'' end) and  (case when '''+@Impt+''' = ''0'' then proveedor2.NDoc else ''1'' end) not like (case when '''+@Impt+''' = ''0'' then ''%IMP%'' else ''2'' end)
 		--	and compra.cd_mda=  (case '''+@Impt+''' when 1 then ''02'' else compra.cd_mda end) 
 			 
 
	group by  proveedor2.Cd_Prv,compra.cd_mda,Proveedor2.RSocial, Proveedor2.ApPat , Proveedor2.ApMat, Proveedor2.Nom  , 
	    FormaPC.Nombre, compra.CA01
	    --, compra.IB_anulado
	



	
'




exec (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd  )
print (@sql + 'Order by ' + @NroCol + ' ' + @TipOrd  )


--Creado Por Rafael Gonzales 29/01/2013
-- Exec  Rpt_ComprasAProveedor  '20102028687', '1/01/2010' , '31/12/2013',     '02'        ,'DESC'               ,''                   ,''            ,0        , ''
-- Exec  Rpt_ComprasAProveedor  RUC___EMPRESA, FECHA_INICIO , FECHA__FINAL,   NUMCOL ,	TIP_ORD(ASC,DESC),  CODIGO_PROVEEDOR,  COD_FPC(FormaPago), DOC_PROVEEDOR, CAMPO


GO

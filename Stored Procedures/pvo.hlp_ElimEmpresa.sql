SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [pvo].[hlp_ElimEmpresa]
@RucE char(11)
as

declare @table_name sysname, @column_name sysname, @column_id int, @schema_name sysname, @OrdDepen int
declare @NroRegs int, @sql nvarchar(4000), @NroTabs int, @NroTotTabs int, @TablasConReg nvarchar(4000), @TablasSinReg nvarchar(4000)
-- declare @RucE char(11)
--set @RucE = '20519885078' --'20100977037' '20110944650' '11111111111'
set @NroTotTabs=0
set @NroTabs=0
set @TablasConReg=''
set @TablasSinReg=''

declare columns_cursor cursor for
select T2.name, T1.name, T1.column_id, SCHEMA_NAME(T2.schema_id) as 'Nombre_Schema',
CASE T2.name when 'Empresa' then 1000 when 'PlanCtas' then 980 when 'MtvoIngSal' then 970 when 'Asiento' then 960 when 'CCostos' then 933 when 'CCSub' then 932 when 'CCSubSub' then 931 when 'Almacen' then 920 when 'Area' then 890 when 'Area1' then 891 when 'Periodo' then 880 when 'Clase' then 833 when 'ClaseSub' then 832 when 'ClaseSubSub' then 831 when 'TipMant' then 825 when 'TipClt' then 821 when 'TipProv' then 820 when 'GrupoSrv' then 815  
when 'ComisionGrupCte' then 791 when 'Cliente2' then 790 when 'Proveedor2' then 780 when 'Caja' then 771 when 'Vendedor2' then 770 when 'Transportista' then 765 when 'Producto2' then 760 when 'Prod_UM' then 750 when 'Servicio2' then 750  when 'ConceptosDetrac' then 740 when 'Precio' then 730 when 'Formula' then 720 when 'CptoCosto' then 715 
when 'SolicitudReq' then 690 when 'SolicitudCom' then 680 when 'Cotizacion' then 681 when 'CotizacionDet' then 680  when 'OrdCompra' then 670 when 'OrdPedido' then 670 when 'OrdFabricacion' then 670 when 'Compra' then 630 when 'Venta' then 630 when 'Importacion' then 620 when 'GuiaRemision' then 610 
when 'CfgAutorizacion' then 450 when 'CfgEnvCorreo' then 440 
when 'Serial' then 370 when 'Catalogo' then 360 when 'Campo' then 350 when 'ReporteFinanciero' then 340 when 'Contrato' then 330 when 'CptoCostoOF' then 320 when 'FabProceso1' then 315 when 'PrdFlujo' then 310 when 'Producto21' then 305   
else 0 end as OrdDepen --Orden Dependencia de Eliminacion
from sys.all_columns T1  
inner join sys.objects T2 on T1.object_id = T2.object_id
where T1.name like '%ruc%' and T2.type='u'
order by OrdDepen asc, T2.object_id desc, 3, 1 --Se deberia ordenar por dependencia de tablas
			
open columns_cursor

	fetch next from columns_cursor into @table_name, @column_name, @column_id, @schema_name, @OrdDepen

	while @@fetch_status = 0
	begin
		set @sql= 'select @Regs = count(*) from ' + @schema_name +'.'+ @table_name + ' where ' + @column_name + '=''' + @RucE + ''''
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		--print @sql
		if (@NroRegs>0)
		begin
			set @TablasConReg = @TablasConReg + '- ' + @schema_name +'.'+@table_name +': '+ convert(varchar, @NroRegs) + case when @column_id=1 then '' else ' (** CNP)' end + char(10)
			set @NroTabs = @NroTabs + 1
			exec ( 'delete from ' + @schema_name +'.'+@table_name +' where ' + @column_name + '=''' + @RucE + '''' )
		end
		else set @TablasSinReg = @TablasSinReg + '> ' + @table_name + char(10)

		set @NroTotTabs = @NroTotTabs +1

		fetch next from columns_cursor into @table_name, @column_name, @column_id, @schema_name, @OrdDepen
	end

close columns_cursor
deallocate columns_cursor
--FIN CURSOR: RECORRE COLUMNAS


declare @RSocial varchar(200)
select @RSocial= RSocial from Empresa where ruc=@RucE


if @NroTabs>0
begin

	print '------------------------------------------------------------------------'
	print 'RESUMEN'
	print '-------'
	print 'Empresa: '+ @RucE + '  ' + @RSocial
	print 'Total tablas: ' + convert(varchar, @NroTotTabs) 
	print 'Total tablas afectadas: ' + convert(varchar, @NroTabs) 
	/*print ''
	print 'Leyenda: '
	print '-------'
	print '(** CPN) --> Columna No Principal'
	print '' + char(10)
	*/
	print 'Lista de tablas afectadas (' + convert(varchar, @NroTabs) +  '): '
	print @TablasConReg
	/*print ''
	print 'Lista de tablas no afectadas (' + convert(varchar, @NroTotTabs-@NroTabs) +  '): '
	print @TablasSinReg
	*/
end
else  
	print 'no hay'



GO

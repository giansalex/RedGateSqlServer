SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [pvo].[hlp_EstadisticaEmpresa]
@RucE char(11)
as


declare @table_name sysname, @column_name sysname, @column_id int, @schema_name sysname
declare @NroRegs int, @sql nvarchar(4000), @NroTabs int, @NroTotTabs int, @TablasConReg nvarchar(4000), @TablasSinReg nvarchar(4000)
--declare @RucE char(11),
--set @RucE = '20519885078' --'20100977037' '20110944650' '20160000001','11111111111'
set @NroTotTabs=0
set @NroTabs=0
set @TablasConReg=''
set @TablasSinReg=''

declare columns_cursor cursor for
select T2.name, T1.name, T1.column_id, SCHEMA_NAME(T2.schema_id) as 'Nombre_Schema' from sys.all_columns T1
inner join sys.objects T2 on T1.object_id = T2.object_id
where T1.name like '%ruc%' and T2.type='u'
order by 3, 1
			
open columns_cursor

	fetch next from columns_cursor into @table_name, @column_name, @column_id, @schema_name

	while @@fetch_status = 0
	begin
		set @sql= 'select @Regs = count(*) from ' + @schema_name +'.'+ @table_name + ' where ' + @column_name + '=''' + @RucE + ''''
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		--print @sql
		if (@NroRegs>0)
		begin
			set @TablasConReg = @TablasConReg + '- ' + @schema_name +'.'+@table_name +': '+ convert(varchar, @NroRegs) + case when @column_id=1 then '' else ' (** CNP)' end + char(10)
			set @NroTabs = @NroTabs + 1
		end
		else set @TablasSinReg = @TablasSinReg + '> ' + @table_name + char(10)

		set @NroTotTabs = @NroTotTabs +1

		fetch next from columns_cursor into @table_name, @column_name, @column_id, @schema_name
	end

close columns_cursor
deallocate columns_cursor
--FIN CURSOR: RECORRE COLUMNAS


declare @RSocial varchar(200)
select @RSocial= RSocial from Empresa where ruc=@RucE

print 'RESUMEN'
print '-------'
print 'Empresa: '+ @RucE + '  ' + @RSocial
print 'Total tablas: ' + convert(varchar, @NroTotTabs) 
print 'Total tablas afectadas: ' + convert(varchar, @NroTabs) 
print ''
print 'Leyenda: '
print '-------'
print '(** CPN) --> Columna No Principal'
print '' + char(10)

print 'Lista de tablas afectadas (' + convert(varchar, @NroTabs) +  '): '
print @TablasConReg
print ''
print 'Lista de tablas no afectadas (' + convert(varchar, @NroTotTabs-@NroTabs) +  '): '
print @TablasSinReg

GO

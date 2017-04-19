SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Cfg_TablaConsxTabla]
@tabla nvarchar(100),
@col_codint nvarchar(100),
@col_cod nvarchar(100),
@col_desc nvarchar(100),
@RucE nvarchar(12),
@where nvarchar(4000),
@msj nvarchar(100) output
as

declare @sql nvarchar(4000)
declare @flag char(1)
set @flag = '0'
--set @tabla = 'Servicio2'
--set @col_cod = 'Cd_Srv'
--set @col_desc = 'Nombre'
--set @RucE = '11111111111'

/*
select * from Cliente2 where Estado = '1'
*/

set @sql = 'select ' + @col_codint + ', ' + @col_cod + ', ' + @col_desc + ' from ' + @tabla + ''

if(LEN(isnull(@RucE,'')) > 0)
begin
	set @sql = @sql + ' where RucE =  '''  + @RucE + '''' 
	set @flag = '1'
end

if(LEN(isnull(@where,'')) > 0)
begin
	if @flag = '1'
		set @sql = @sql + ' and '  + @where
	else
		set @sql = @sql + ' where '  + @where
end
 
print @sql
exec (@sql)

GO

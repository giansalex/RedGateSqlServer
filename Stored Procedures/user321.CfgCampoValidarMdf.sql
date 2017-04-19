SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CfgCampoValidarMdf]
@RucE nvarchar(11),
@Id_CTb int,
@msj varchar(100) output
as

/*declare @msj varchar(100)
declare @RucE nvarchar(11)
set @RucE = '11111111111'
declare @Id_CTb int
set @Id_CTb = 1*/

declare @nomCol nvarchar(4), @nomVentana nvarchar(400)

select @nomCol = c.NomCol, @nomVentana = t.Nombre from CampoTabla c 
inner join Tabla t on c.Cd_Tab = t.Cd_Tab
where c.Id_CTb = @Id_CTb 
print @nomCol
print @nomVentana

declare @sql1 nvarchar(400)
set @sql1 = 'select @Nrows = count(*) from ' + @nomVentana + ' where RucE = ''' + @RucE + 
		''' and '  + @nomCol + ' is not null and ' + @nomCol + ' != '''' '

declare @rows int
exec sp_executesql @sql1, N'@Nrows int output', @rows output

if @rows != 0
	set @msj = 'Hay datos en la columna'

print @rows
print @msj

-- MP : 2011-01-21 : <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CopiaDatosxTabla]
@RucEAnt nvarchar(11),
@RucE nvarchar(11),
@tabla nvarchar(1000)
as

--declare @RucEAnt nvarchar(11)
--declare @RucE nvarchar(11)
--declare @tabla nvarchar(1000)
declare @selectTabla varchar(8000)
declare @name nvarchar(1000)

--set @RucEAnt = '11111111111'
--set @RucE = '22222222222'
--set @tabla = 'dbo.Venta'
set @selectTabla = 'insert into '+ @tabla + '
select '

declare cNombreTabla cursor for

SELECT name FROM sys.columns WHERE object_id = OBJECT_ID(@tabla)
-- Apertura del cursor
OPEN cNombreTabla

-- Lectura de la primera fila del cursor
FETCH cNombreTabla INTO @name

WHILE (@@FETCH_STATUS = 0 )
BEGIN


IF @name = 'RucE'
BEGIN
	SET @selectTabla = @selectTabla + '''' + @RucE + ''' RucE' + ','
END
ELSE IF @name = 'Ruc'
BEGIN
	SET @selectTabla = @selectTabla + '''' + @RucE + ''' Ruc' + ','
END
ELSE
BEGIN
	SET @selectTabla = @selectTabla + @name + ','
END


-- Lectura de la siguiente fila del cursor
FETCH cNombreTabla INTO @name

END

-- Cierre del cursor
CLOSE cNombreTabla

-- Liberar los recursos
DEALLOCATE cNombreTabla


SET @selectTabla = LEFT(@selectTabla, LEN(@selectTabla) - 1) + ' 
from ' + @tabla + ' WHERE RucE = '''+ @RucEAnt +''' '
PRINT @selectTabla
EXEC (@selectTabla)

--MP : 04/04/2012 : <Creacion del procedimiento almacenado>
GO

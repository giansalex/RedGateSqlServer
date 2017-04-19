SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_TemporalCons]
@RucE nvarchar(11),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@msj varchar(100) output
AS
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.Temporal'+@RucE))
exec ('drop table dbo.Temporal'+@RucE)
EXEC ('CREATE TABLE dbo.Temporal'+@RucE+'(Cd_VtaX nvarchar(10) NOT NULL)')
DECLARE @cabecera nvarchar(50) --Variable para las columnas
DECLARE @exec1 nvarchar(1024)  --Variable para la definicion de consulta en tiempo de ejecucion
DECLARE @exec2 nvarchar(1024)  --Variable para la definicion de consulta en tiempo de ejecucion
DECLARE @Valor nvarchar(50)
DECLARE @Cd_Vta nvarchar(10), @Cd_Cp nvarchar(2), @Nombre nvarchar(50)

EXEC ('INSERT INTO dbo.Temporal'+@RucE+'(Cd_VtaX) SELECT DISTINCT Cd_Vta FROM Venta where RucE='''+@RucE+''' and Prdo>='''+@PrdoD+''' and Prdo<='''+@PrdoH+''' Order by 1')

DECLARE encabezado CURSOR FOR
SELECT Nombre FROM Campo WHERE RucE=@RucE and IB_Exp=1 Order by Cd_Cp asc
OPEN encabezado
	FETCH NEXT from encabezado INTO @cabecera
	-- mientras haya datos
	WHILE @@FETCH_STATUS = 0
		BEGIN
			-- por cada nombre de Campo, agregar una columna a Temporal
			SET @exec1 = 'ALTER TABLE Temporal'+@RucE+' ADD [' + @cabecera + '] NVARCHAR(50) NULL'
			EXECUTE (@exec1)
			print @cabecera
			FETCH NEXT from encabezado INTO @cabecera
		END
CLOSE encabezado
DEALLOCATE encabezado

Print '**************************************************'


DECLARE selventa CURSOR FOR
SELECT DISTINCT ve.Cd_Vta,cv.Cd_Cp,cp.Nombre FROM Venta ve, CampoV cv, Campo cp WHERE ve.RucE=@RucE and ve.RucE=cv.RucE and ve.RucE=cp.RucE and ve.Cd_Vta=cv.Cd_Vta and cv.Cd_Cp=cp.Cd_Cp and ve.Prdo>=@PrdoD and ve.Prdo<=@PrdoH and cp.IB_Exp=1 Order by 1
OPEN selventa
	FETCH NEXT FROM selventa INTO @Cd_Vta,@Cd_Cp,@Nombre
	WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @Valor = (SELECT cv.Valor FROM CampoV cv WHERE cv.RucE=@RucE and cv.Cd_Vta=@Cd_Vta and cv.Cd_Cp=@Cd_Cp)
		
		SET @exec2 = 'UPDATE Temporal'+@RucE+' SET [' + @Nombre + '] = ''' + @Valor + '''' + ' WHERE Cd_VtaX = ''' + @Cd_Vta + ''''
		EXECUTE (@exec2)
		
		FETCH NEXT FROM selventa INTO @Cd_Vta,@Cd_Cp,@Nombre
		END

CLOSE selventa
DEALLOCATE selventa
GO

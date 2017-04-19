SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_Permisos_X_Cfg]
AS
DECLARE @Cd_Pm NVARCHAR(4)
DECLARE @colums VARCHAR(1000)
SET @colums = ''

DECLARE cur_Perm CURSOR FOR SELECT Cd_Pm FROM Permisos WHERE Estado = 1
OPEN cur_Perm
	FETCH NEXT FROM cur_Perm INTO @Cd_Pm
	-- mientras haya datos
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @colums = @colums + @Cd_Pm +', '
		FETCH NEXT from cur_Perm INTO @Cd_Pm
		END
CLOSE cur_Perm
DEALLOCATE cur_Perm

SET @colums = left(@colums,len(@colums)-1)
PRINT @colums

DECLARE @SQL nvarchar(4000)

SET @SQL= 
	'select Cd_CfgPm,Descrip,'+@colums+',''N'' as Accion from PermisosCfg'
PRINT @SQL
EXEC(@SQL)


SELECT Cd_Pm,Descrip,0 Permitir FROM Permisos where Estado=1

--Leyenda--
-----------

-- DI : 02/09/2009 Se creo el procedimiento almacenado
-- DI : 14/09/2009 Se agregi la columna Accion 
			--(dato por defecto : N - Ninguno
			--	              A - Agregado 
			--	              M - Modificado
			--	              E - Eliminado)

GO

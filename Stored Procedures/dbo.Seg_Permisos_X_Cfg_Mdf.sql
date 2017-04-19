SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Seg_Permisos_X_Cfg_Mdf]
@Cd_CfgPm int,
@Descrip varchar(50),
@ColPm varchar(200),
@msj varchar(100) output
as

Declare @SQL nvarchar(4000)
	Set @SQL = ''
	Set @SQL =
		'
		update PermisosCfg set Descrip='''+@Descrip+''','+@ColPm+' 
		where Cd_CfgPm='+Convert(varchar,@Cd_CfgPm)
	Print @SQL
	Exec(@SQL)
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al modificar configuracion de permiso'
	end

print @msj

-- Leyenda --
-------------
-- DI -> 15/09/2009 : Creacion del SP
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Seg_Permisos_X_Cfg_Crea]
@Descrip varchar(50),
@ColPm varchar(500),
@ValPm varchar(500),
@msj varchar(100) output
as

Declare @Cd_CfgPm nvarchar(2)
Set @Cd_CfgPm = (select convert(nvarchar,isnull(Max(Cd_CfgPm),0)+1) from PermisosCfg)
print @Cd_CfgPm
print @ColPm
print @ValPm

Declare @SQL nvarchar(4000)
	Set @SQL = ''
	Set @SQL =
		'
		insert into PermisosCfg(Cd_CfgPm,Descrip,'+@ColPm+',Estado)
		values('+@Cd_CfgPm+','''+@Descrip+''','+@ValPm+',1)
		'
	Print @SQL
	Exec(@SQL)
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al crear configuracion de permiso'
	end

print @msj

-- Leyenda --
-------------
-- DI -> 15/09/2009 : Creacion del SP
GO

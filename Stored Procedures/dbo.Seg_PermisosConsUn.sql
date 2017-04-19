SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosConsUn]
@Cd_Pm nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Permisos where Cd_Pm=@Cd_Pm)
	set @msj = 'Permiso no existe'
else	select * from Permisos
print @msj
GO

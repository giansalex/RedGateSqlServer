SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Gfm_MantenimientoGNElim](
	@RucE	nvarchar(11)			,
	@Cd_TM	char(2)					,
	@Cd_Mnt	char(6)					,
	@msj	varchar(100)	output
)
as
if not exists ( select * from MantenimientoGN where RucE = @RucE and Cd_TM = @Cd_TM and Cd_Mnt = @Cd_Mnt)
	set @msj = 'Mantenimiento no existe.'
else
begin
	delete MantenimientoGN Where RucE = @RucE and Cd_TM = @Cd_TM and Cd_Mnt = @Cd_Mnt
	
	if @@rowcount <= 0
		set @msj = 'Mantenimiento no pudo ser eliminado.'
end
print @msj
GO

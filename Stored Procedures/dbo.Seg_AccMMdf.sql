SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccMMdf]
@Itm_AE int,
@Cd_MN nvarchar(10),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from AccesoM where Itm_AE=@Itm_AE and Cd_MN=@Cd_MN)
	set @msj = 'Acceso no existe'
else
begin
	update AccesoM set Estado=@Estado
	where Itm_AE=@Itm_AE and Cd_MN=@Cd_MN

	if @@rowcount <= 0
           set @msj = 'Acceso no pudo ser modificado'
end
print @msj
GO

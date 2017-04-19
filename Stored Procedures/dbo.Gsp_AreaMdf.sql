SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_AreaMdf]
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@Descrip varchar(50),
@NCorto varchar(6),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Area where RucE=@RucE and Cd_Area=@Cd_Area)
	set @msj = 'Area no existe'
else
begin
	update Area set Cd_Area=@Cd_Area, Descrip=@Descrip, NCorto=@NCorto, Estado=@Estado
		where RucE=@RucE and Cd_Area=@Cd_Area
	if @@rowcount <= 0
		set @msj = 'Area no pudo ser modificado'
end
print @msj
GO

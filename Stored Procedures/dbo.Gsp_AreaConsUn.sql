SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_AreaConsUn]
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from Area where RucE=@RucE and Cd_Area=@Cd_Area)
	set @msj = 'Area no existe'
else	select * from Area where RucE=@RucE and Cd_Area=@Cd_Area
print @msj

GO

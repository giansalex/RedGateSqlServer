SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieConsUn]
@RucE nvarchar(11),
@Cd_Sr nvarchar(4),
@msj varchar(100) output
as 
if not exists (select * from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr)
	set @msj = 'Serie no existe'
else	select * from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr
print @msj
GO

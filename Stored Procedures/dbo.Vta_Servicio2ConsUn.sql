SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2ConsUn]
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Servicio2 where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else	
	select * from Servicio2 Where RucE=@RucE and Cd_Srv=@Cd_Srv
print @msj
GO

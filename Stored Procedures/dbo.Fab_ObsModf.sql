SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ObsModf]

@RucE nvarchar(11),
@Cd_Fab char(10) output,
@ID_Obs int,
@ID_Eta int,
@FecObs datetime,
@Titulo varchar(100),
@Obs varchar(1000),
@Resp varchar(50),
@Conclu varchar(1000),
@Ruta varchar(100),
@UsuModf varchar(10),
@msj varchar(100) output
as

if not exists (select * from FabObs where RucE=@RucE and Cd_fab=@Cd_fab and ID_Obs=@ID_Obs)
	Set @msj = 'No existe numero de la Observacion'
else
begin 
	update FabObs set
	FecObs=@FecObs,Titulo=@Titulo,Obs=@Obs,Resp=@Resp,Conclu=@Conclu,Ruta=@Ruta,
	UsuModf=@UsuModf,FecMdf=getdate()
	where RucE=@RucE and Cd_fab=@Cd_Fab and ID_Obs=@ID_Obs and ID_Eta=@ID_Eta
	if @@rowcount <= 0
		Set @msj = 'Error al modificar la fabricacion'
end
	
--LEYENDA:
-- CE: 22/01/2013 -> <<Creacion del SP>>
	
GO

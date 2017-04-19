SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ObsCrea]

@RucE nvarchar(11),
@Cd_Fab char(10) output,
@ID_Obs int output,
@ID_Etapa int,
@FecObs datetime,
@Titulo varchar(100),
@Obs varchar(1000),
@Resp varchar(50),
@Conclu varchar(1000),
@Ruta varchar(100),
@UsuCrea varchar(10),
@msj varchar(100) output
as

set @ID_Obs = dbo.ID_Obs(@RucE)--funcion
if exists (select * from FabObs where RucE=@RucE and Cd_Fab=@Cd_Fab and ID_Obs=@ID_Obs)
		Set @msj = 'Ya existe numero de Observacion (Fabricacion)'
else
	begin 
		insert into FabObs(RucE, Cd_Fab, ID_Obs, ID_Eta, FecObs, Titulo, Obs, Resp, Conclu, Ruta, FecReg, UsuCrea)
					values(@RucE, @Cd_Fab, @ID_Obs, @ID_Etapa, @FecObs, @Titulo, @Obs, @Resp, @Conclu, @Ruta, getdate(), @UsuCrea)
		if @@rowcount <= 0
			set @msj = 'Observacion de Fabricacion no pudo ser ingresado'
	end
	
--LEYENDA:
-- CE: 22/01/2013 -> <<Creacion del SP>>
	
GO

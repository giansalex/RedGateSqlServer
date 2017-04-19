SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_SolicitudCom_MdfEstado2]
@RucE nvarchar(11),
@Cd_SCo char(10),
@Id_EstSC char(2),
@msj varchar(100) output
as

--Actualizar el estado de la solicitud
update SolicitudCom
set Id_EstSC = @Id_EstSC
where RucE = @RucE and Cd_SCo = @Cd_SCo

if(@@rowcount = 0)
	set @msj = 'No se pudo modificar el estado de la solicitud'
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_SolicitudCom_MdfEstado]
@RucE nvarchar(11),
@Cd_SCo char(10),
@Id_EstSC char(2),
@Cd_Prv char(7),
@msj varchar(100) output
as

if not exists (select * from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_Prv = @Cd_Prv)
begin
	set @msj = 'No existe el proveedor por la solicitud seleccionada'
	return
end

--Establecer el proveedor aceptado
update SCxProv
set IB_Acp = 1
where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_Prv = @Cd_Prv

if(@@rowcount = 0)
begin
	set @msj = 'No se pudo establecer el proveedor aceptado'
	return
end

--Actualizar el estado de la solicitud
update SolicitudCom
set Id_EstSC = @Id_EstSC
where RucE = @RucE and Cd_SCo = @Cd_SCo

if(@@rowcount = 0)
	set @msj = 'No se pudo modificar el estado de la solicitud'


GO

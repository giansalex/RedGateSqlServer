SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_SolicitudCom_Establecer_ProvAprov]
@RucE nvarchar(11),
@Cd_SCo char(10),
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
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_SolicitudComCons_AprovProv]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as
declare @estado char(2)
declare @auto bit
select @auto = (case(isnull(TipAut,0)) when 0 then 1 else IB_Aut end) from SolicitudCom where Cd_SCo = @Cd_SCo and RucE = @RucE

--exec Cfg_ConsultarDocAutorizado (@RucE, @Cd_SCo, 2, @msjAut output)
if(@auto = 0)
begin
	set @msj = 'Para aprobar con proveedor primero tiene que autorizar el documento'
	return
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select @estado = Id_EstSC from solicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo

--if(@estado = '01') set @msj = 'No puede aprobar el documento. Aun no ha sido enviado al proveedor'
if(@estado = '01') set @msj = 'La solicitud aun no se envia a un proveedor. No se puede aprobar el documento.'
if(@estado = '08' or @estado = '09') set @msj = 'El documento ya se aprobó.'
if(@estado = '10') set @msj = 'El documento fue cancelado.'
GO

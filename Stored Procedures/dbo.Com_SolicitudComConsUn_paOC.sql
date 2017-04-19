SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SolicitudComConsUn_paOC]

@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output

as 
	set @msj = 'Debe actualizar el sistema. Póngase en contacto con el área de sistemas.'
/*
if not exists (select * from SolicitudCom where RucE=@RucE and Cd_Sco=@Cd_SCo)
	Set @msj = 'No existe Solicitud de Compra'
else
begin
/*
	select	sc.Cd_SCo, sc.NroSC,sc.Cd_FPC, sc.Cd_Area,sc.Cd_CC,sc.Cd_SC, sc.Cd_SS          
	from SolicitudCom sc
	where sc.RucE=@RucE and sc.Cd_SCo=@Cd_SCo
*/
	select	sc.Cd_SCo, sc.NroSC,sc.Cd_FPC, sc.Cd_Area,sc.Cd_CC,sc.Cd_SC, sc.Cd_SS, sp.Cd_Prv, pv.Cd_TDI, 
		case(pv.RSocial) when '' then pv.appat+' '+pv.apmat+', '+pv.nom else pv.rsocial end DescPrv, pv.NDoc
	from SolicitudCom sc 
	join SCxProv sp on sp.Cd_SCo = sc.Cd_Sco and sp.IB_Acp = 1
	join Proveedor2 pv on pv.Cd_Prv = sp.Cd_Prv and pv.RucE = @RucE
	where sc.Cd_SCo=@Cd_SCo and sc.RucE=@RucE

end
*/
-- Leyenda --
-- JU   : 2010-08-04 : <Creacion del procedimiento almacenado>
-- MM:  2010-08-04 : <Creacion del procedimiento almacenado>
GO

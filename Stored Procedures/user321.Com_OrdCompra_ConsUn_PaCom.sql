SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_OrdCompra_ConsUn_PaCom]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
if not exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC)
	Set @msj = 'No existe Orden de Compra'
else
begin
	select oc.Cd_OC, oc.Cd_FPC, oc.Cd_Area, oc.Cd_Prv, p2.Cd_TDI as Cd_TDI_Prv,p2.NDoc as  NDoc_Prv,  
	case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nomb_Prv,
	oc.Cd_CC, oc.Cd_SC, oc.Cd_SS,
	oc.Cd_Mda, oc.CamMda, oc.CA01, oc.CA02, oc.CA03, oc.CA04, oc.CA05, oc.CA06, oc.CA07, oc.CA08, oc.CA09, oc.CA10
	from OrdCompra as oc left join Proveedor2 p2 on p2.Cd_Prv=oc.Cd_Prv and p2.RucE=oc.RucE
	where oc.RucE=@RucE and oc.Cd_OC=@Cd_OC
end
-- Leyenda --
-- JU : 2010-09-08 : <Creacion del procedimiento almacenado>
-- exec Com_OrdCompra_ConsUn_PaCom '11111111111', 'OC00000017' , null

GO

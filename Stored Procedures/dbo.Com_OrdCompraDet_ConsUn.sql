SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraDet_ConsUn]
@RucE nvarchar(11),
@Cd_OC char(10),
@Item int,
@msj varchar(100) output
as
if not exists (select * from OrdCompraDet where RucE=@RucE and Cd_OC=@Cd_OC and Item=@Item)
	Set @msj = 'No existe Orden de Compra Detalle'
else
begin
	select	oc.Item, oc.Cd_OC,oc.Cd_Prod, oc.Descrip, oc.PU,oc.ID_UMP ,um.DescripAlt as UM,oc.Cant, oc.PendRcb, oc.Valor, oc.DsctoP, oc.DsctoI, oc.BIM,oc.IGV,
		case(isnull(oc.IGV,0))when 0 then 0 else 1 end as IncIGV,oc.Total, oc.Cd_Alm, oc.Obs, oc.CA01,oc.CA02,oc.CA03,oc.CA04,oc.CA05
	from OrdCompraDet oc
	inner join Prod_UM um on oc.RucE = um.RucE and oc.Cd_Prod = um.Cd_Prod and oc.ID_UMP= um.ID_UMP
	where oc.RucE=@RucE and oc.Cd_OC=@Cd_OC and oc.Item = @Item
end
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO

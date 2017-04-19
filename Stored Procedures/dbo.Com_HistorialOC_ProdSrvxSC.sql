SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_HistorialOC_ProdSrvxSC]
@RucE varchar(11),
@Cd_SC char(10),
@Cd_Prv varchar(14),
@Cd_Prod char(7),
@ID_UMP int,
@Cd_Srv char(7),
@ItemSC int,
@msj varchar(100) output
as
if not exists (select * from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SC)
begin
	set @msj = 'No existe la solicitud de compra con el codigo  ' + @Cd_SC
	return
end
if(@Cd_Prod is null or LEN(@Cd_Prod) = 0 or @Cd_Prod = '')
begin
	select	oc.Cd_OC, Cd_Prod, ID_UMP, Cd_SRV, isnull(ocd.Valor,0.0000) Valor, 
			isnull(DsctoP,0.00) DsctoP, isnull(DsctoI,0.0000) DsctoI, isnull(ocd.BIM,0.0000) BIM, 
			isnull(ocd.IGV,0.0000) IGV, isnull(PU,0.0000) PU, isnull(Cant,0.0000) Cant, 
			isnull(ocd.Total,0.0000) Total
	from OrdCompraDet ocd
	join OrdCompra oc on oc.RucE = ocd.RucE and oc.CD_OC = ocd.Cd_OC
	--where ocd.RucE = @RucE and ocd.Cd_SCo = @Cd_SC and oc.Cd_Prv = @Cd_Prv and ocd.Cd_SRV = @Cd_Srv
	where ocd.RucE = @RucE and oc.Cd_Prv = @Cd_Prv and ocd.Cd_SRV = @Cd_Srv and ocd.ItemSC = @ItemSC
end
else if (@Cd_Srv is null or LEN(@Cd_Srv) = 0 or @Cd_Srv = '')
begin
	select	oc.Cd_OC, Cd_Prod, ID_UMP, Cd_SRV, isnull(ocd.Valor,0.0000) Valor, 
			isnull(DsctoP,0.00) DsctoP, isnull(DsctoI,0.0000) DsctoI, isnull(ocd.BIM,0.0000) BIM, 
			isnull(ocd.IGV,0.0000) IGV, isnull(PU,0.0000) PU, isnull(Cant,0.0000) Cant, 
			isnull(ocd.Total,0.0000) Total
	from OrdCompraDet ocd
	join OrdCompra oc on oc.RucE = ocd.RucE and oc.CD_OC = ocd.Cd_OC
	--where ocd.RucE = @RucE and ocd.Cd_SCo = @Cd_SC and oc.Cd_Prv = @Cd_Prv and ocd.Cd_Prod = @Cd_Prod and ocd.ID_UMP = @ID_UMP
	where ocd.RucE = @RucE and oc.Cd_Prv = @Cd_Prv and ocd.Cd_Prod = @Cd_Prod and ocd.ID_UMP = @ID_UMP and ocd.ItemSC = @ItemSC
end

--	LEYENDA
/*	MM : <29/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_HistorialOC_ProdSrvxSC '11111111111','SC00000167','PRV0227','PD00091',1,'',null
 
*/
GO

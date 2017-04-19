SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_ConsUnparaInv3]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as if not exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC)
	set @msj = 'No existe Orden de Compra'
else
begin
	select	oc.Cd_OC, oc.NroOC,pr.Cd_TDI as Cd_TDI_Prv,pr.NDoc, oc.Cd_Prv,case(isnull(len(pr.RSocial),0)) when 0 then pr.ApPat +' '+ pr.ApMat +','+ pr.Nom 
		else pr.RSocial end as Nomb_Prv, Convert(nvarchar,oc.FecE,103) as FecE,Convert(nvarchar,oc.FecEntR,103) as FecEntR,
                oc.Cd_FPC,oc.Cd_Area,oc.Obs,oc.Valor,oc.TotDsctoP,oc.TotDsctoI,oc.ValorNeto,
                oc.DsctoFnzP,oc.DsctoFnzI,oc.BIM,oc.IGV,oc.Total,oc.Cd_Mda,oc.CamMda,oc.IB_Aten,oc.AutdoPorN1,case(oc.IC_NAut) when '1' then 'Autorizacion Nivel 1'
			when '2' then 'Autorizacion Nivel 2' when '3' then 'Autorizacion Nivel 3' else '' end as IC_NAut,Cd_SCo,oc.Cd_CC,oc.Cd_SC,oc.Cd_SS,
		oc.CA01,oc.CA02,oc.CA03,oc.CA04,oc.CA05,oc.CA06,oc.CA07,oc.CA08,oc.CA09,oc.CA10,oc.CA11,oc.CA12,oc.CA13,oc.CA14,oc.CA15,us1.NomComp as NAut1,us2.NomComp as NAut2,us3.NomComp as NAut3, 
		CantDet.Item as CantItem, oc.TipAut, oc.AutdoPorN1, oc.AutorizadoPor
		,oc.Asunto
	from OrdCompra oc
	inner join Proveedor2 pr on pr.RucE=oc.RucE and pr.Cd_Prv=oc.Cd_Prv
	left join (select MAX(Item) as Item, Cd_OC, RucE from OrdCompraDet where Cd_OC = @Cd_OC and RucE = @RucE group by Cd_OC,RucE) as CantDet
	on oc.RucE = CantDet.RucE and oc.Cd_OC = CantDet.Cd_OC
	left join Usuario us1 on oc.AutdoPorN1 = us1.NomUsu 
	left join  Usuario us2 on oc.AutdoPorN2 = us2.NomUsu 
	left join  Usuario us3 on oc.AutdoPorN3 = us3.NomUsu  
	where oc.RucE=@RucE and oc.Cd_OC=@Cd_OC
end
-- Leyenda --
-- CAM : 06/12/10 : <Creacion del procedimiento almacenado>
-- DI : 02/03/2011 : <Se agrego la columna asunto>
-- PP : 2011-07-14 ; <Se agrego la columna Asunto CA>

GO

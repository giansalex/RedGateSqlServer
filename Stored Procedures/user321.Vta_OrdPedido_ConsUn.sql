SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_OrdPedido_ConsUn]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as
if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP)
	Set @msj = 'No existe Orden de Pedido'
else
begin
	select	op.Cd_OP, op.NroOP,vr.Cd_TDI as Cd_TDI_Vdr,op.Cd_Vdr, vr.NDoc as NDoc_Vdr,(vr.ApPat +' '+vr.ApMat+', '+vr.Nom) as Nom_Vdr,cl.Cd_TDI as Cd_TDI_Clt,op.Cd_Clt,
		cl.NDoc as NDoc_Clt, case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +' '+ cl.ApMat +','+ cl.Nom 
		else cl.RSocial end as Nomb_Clt, Convert(nvarchar,op.FecE,103) as FecE,Convert(nvarchar,op.FecEnt,103) as FecEnt,
                op.Cd_FPC,op.Cd_Area,op.Obs,op.DirecEnt,op.Valor,op.TotDsctoP,op.TotDsctoI,op.ValorNeto,op.INF,
                op.DsctoFnzInf_P,op.DsctoFnzInf_I,op.INF_Neto,op.BIM,op.DsctoFnzAf_P,op.DsctoFnzAf_I,op.BIM_Neto,op.IGV,op.Total,op.Cd_Mda,op.CamMda,
		op.CA01,op.CA02,op.CA03,op.CA04,op.CA05,op.CA06,op.CA07,op.CA08,op.CA09,op.CA10,op.Cd_CC, op.Cd_SC, op.Cd_SS,
		CantDet.Item as CantItem, TipAut, IB_Aut, AutorizadoPor, Id_EstOP
	from OrdPedido op
	left join Vendedor2 vr on vr.RucE=op.RucE and vr.Cd_Vdr=op.Cd_Vdr
	left join Cliente2 cl on cl.RucE=op.RucE and cl.Cd_Clt=op.Cd_Clt
	left join (select MAX(Item) as Item, Cd_OP, RucE from OrdPedidoDet where Cd_OP = @Cd_OP and RucE = @RucE group by Cd_OP,RucE) as CantDet
	on op.RucE = CantDet.RucE and op.Cd_OP = CantDet.Cd_OP
	where op.RucE=@RucE and op.Cd_OP=@Cd_OP

	
end
-- Leyenda --
-- JJ : 2010-08-06 : <Creacion del procedimiento almacenado>
-- JU : 2010-08-11 : <Modificacion del procedimiento almacenado>
-- MM : 2010-02-03 : <Modificacion del procedimiento almacenado> : Se agrego el campo 'AutorizadoPor'
-- CAM: 2011-03-28 : <Agregue el campo Id_EstOP>
GO

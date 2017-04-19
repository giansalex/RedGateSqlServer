SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_OrdPedido_ConsUn_PaVta]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as
if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP)
	Set @msj = 'No existe Orden de Pedido'
else
begin
	select 
	op.RucE,
	op.Cd_OP,
	op.Cd_FPC,
	op.Cd_Vdr,
	ve.Cd_TDI as Cd_TDI_Vdr,
	ve.NDoc as NDoc_Vdr,
	(ve.ApPat +' '+ve.ApMat+', '+ve.Nom) as Nomb_Vdr,
	op.Cd_Area,
	op.Cd_Clt,
	cl.Cd_TDI as Cd_TDI_Clt,
	cl.NDoc as NDoc_Clt,
	case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +' '+ cl.ApMat +','+ cl.Nom else cl.RSocial end as Nomb_Clt,
	op.Valor,
	op.TotDsctoP,
	op.TotDsctoI,
	op.ValorNeto,
	op.INF_Neto,
	op.BIM_Neto,
	op.IGV,
	op.Total,
	op.Cd_Mda,
	op.CamMda,
	op.CA01,
	op.CA02,
	op.CA03,
	op.CA04,
	op.CA05,
	op.CA06,
	op.CA07,
	op.CA08,
	op.CA09,
	op.CA10
	from OrdPedido as op 
left join Cliente2 cl on cl.RucE = op.RucE and cl.Cd_Clt = op.Cd_Clt
left join Vendedor2 ve on ve.RucE = op.RucE and ve.Cd_Vdr = op.Cd_Vdr
	where op.RucE=@RucE and op.Cd_OP=@Cd_OP
end
-- Leyenda --
-- JU : 2010-10-07 : <Creacion del procedimiento almacenado>
-- exec Vta_OrdPedido_ConsUn_PaVta '11111111111', 'OC00000017' , null

GO

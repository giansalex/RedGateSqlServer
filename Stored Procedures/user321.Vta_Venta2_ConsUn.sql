SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_Venta2_ConsUn]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	Set @msj = 'No existe Venta'
else
begin


select
vd.RucE,
vd.Cd_Vta,
vd.Eje,
vd.Prdo,
vd.RegCtb,
Convert(nvarchar,vd.FecMov,103) as FecMov,
vd.Cd_FPC,
Convert(nvarchar,vd.FecCbr,103) as FecCbr, 
vd.Cd_TD,
vd.NroDoc,
Convert(nvarchar,vd.FecED,103) as FecED,
Convert(nvarchar,vd.FecVD,103) as FecVD, 
vd.Cd_Area,
vd.Cd_MR,
vd.Obs,
vd.Valor,
vd.TotDsctoP,
vd.TotDsctoI,
vd.ValorNeto,
vd.BaseSinDsctoF,
vd.DsctoFnz_P,
vd.DsctoFnz_I,
vd.Cd_IAV_DF,
vd.INF_Neto,
vd.EXO_Neto,
vd.EXPO_Neto,
vd.BIM_Neto,
vd.IGV,
vd.Total,
vd.Percep,
vd.Cd_Mda,
vd.CamMda,
vd.IB_Anulado,
vd.IB_Cbdo,
vd.CA01,
vd.CA02,
vd.CA03,
vd.CA04,
vd.CA05,
vd.CA06,
vd.CA07,
vd.CA08,
vd.CA09,
vd.CA10,
vd.CA11,
vd.CA12,
vd.CA13,
vd.CA14,
vd.CA15,
vd.CA16,
vd.CA17,
vd.CA18,
vd.CA19,
vd.CA20,
vd.CA21,
vd.CA22,
vd.CA23,
vd.CA24,
vd.CA25,
vd.Cd_OP,
vd.Cd_CC,
vd.Cd_SC,
vd.Cd_SS,
vd.NroSre,
vd.Cd_MIS,
vd.UsuCrea,
mt.Descrip as Descrip_MIS,
vd.Cd_Clt,
cl.Cd_TDI as Cd_TDI_Clt,
cl.NDoc as NDoc_Clt,
case(isnull(len(cl.RSocial),0)) when 0 then isnull(cl.ApPat,'') +' '+ isnull(cl.ApMat,'') +','+ isnull(cl.Nom,'') else isnull(cl.RSocial,'') end as Nomb_Clt,
cl.direc as DirecClie,
vd.Cd_Vdr,
ve.Cd_TDI as Cd_TDI_Vdr,
ve.NDoc as NDoc_Vdr,
(isnull(ve.ApPat,'') +' '+isnull(ve.ApMat,'')+', '+isnull(ve.Nom,'')) as Nomb_Vdr,
----------------------------------DocRef---------
DR_CdVta,
Convert(nvarchar,vd.DR_FecED,103) as DR_FecED,
DR_CdTD,
DR_NSre,
DR_NDoc
from Venta vd 
left join Cliente2 cl on cl.RucE = vd.RucE and cl.Cd_Clt = vd.Cd_Clt
left join Vendedor2 ve on ve.RucE = vd.RucE and ve.Cd_Vdr = vd.Cd_Vdr
left join MtvoIngSal mt on mt.RucE = vd.RucE and mt.Cd_MIS = vd.Cd_MIS
where 	vd.RucE=@RucE and vd.Cd_Vta=@Cd_Vta
end
--exec Vta_Venta2_Cons '11111111111','VT00000125',null
-- Leyenda --
-- JJ : 2010-09-15 : <Creacion del procedimiento almacenado>
-- JU : 2010-10-01 : <Modificacion del procedimiento almacenado>
-- DI : 2011-05-04 : <Modificacion del nombre del cliente y vendedor se agrego sintaxis isnull>
-- MP : 2011-11-21 : <Agregue mas campos adicionales>

GO

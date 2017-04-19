SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_CotizacionVtaConsUn_paOP]
@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output

as 
if not exists (select * from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe Cotizacion'
else
begin
	select	co.Cd_Cot, co.NroCot,co.Cd_FPC, co.Cd_Clt,cl.Cd_TDI as Cd_TDI_Clt,cl.NDoc as NDoc_Clt,case(isnull(len(cl.RSocial),0))when 0 then cl.ApPat+' '+cl.ApMat+' '+cl.Nom else cl.RSocial end as Nomb_Clt,
	co.Cd_Vdr,ve.Cd_TDI as Cd_TDI_Vdr,ve.NDoc as NDoc_Vdr,ve.ApPat + ' ' + ve.ApMat + ',' + ve.Nom as Nomb_Vdr,co.Cd_Area, co.Cd_Mda, co.CamMda, co.Obs,
		co.Valor,co.TotDsctoP,co.TotDsctoI,co.INF,co.DsctoFnzInf_P,co.DsctoFnzInf_I,co.INF_Neto,
		co.BIM,co.DsctoFnzAf_P,co.DsctoFnzAf_I,co.BIM_Neto,co.IGV,co.Total
	from Cotizacion co left join Vendedor2 ve on co.RucE = ve.RucE and co.Cd_Vdr = ve.Cd_Vdr
	left join Cliente2 cl on co.RucE = cl.RucE and co.Cd_Clt = cl.Cd_Clt
	where co.RucE=@RucE and co.Cd_Cot=@Cd_Cot
end
-- Leyenda --
-- JJ : 2010-08-06 : <Creacion del procedimiento almacenado>
-- JU : 2010-08-10 : <Modificacion del procedimiento almacenado>
GO

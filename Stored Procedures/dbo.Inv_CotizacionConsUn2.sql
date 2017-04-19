SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Inv_CotizacionConsUn2]

/*
exec Inv_CotizacionConsUn '11111111111','CT00000002',null
*/

@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output

as
if not exists (select * from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe cotizacion'
else
begin
	select	c.Cd_Cot,c.NroCot,c.FecEmi,c.FecCad,
                c.Cd_FPC,c.Asunto,c.Cd_Clt,c.Cd_Vdr,c.CostoTot,c.Valor,c.TotDsctoP,c.TotDsctoI,c.INF,
                c.DsctoFnzInf_P,c.DsctoFnzInf_I,c.INF_Neto,c.BIM,c.DsctoFnzAf_P,c.DsctoFnzAf_I,c.BIM_Neto,c.IGV,c.Total,c.MU_Porc,
                c.MU_Imp,c.Cd_Mda,c.CamMda,c.Cd_Area,c.Obs,c.CdCot_Base,c.Id_EstC,c.Cd_FCt,c.CA01,c.CA02,c.CA03,c.CA04,c.CA05,
                c.CA06,c.CA07,c.CA08,c.CA09,c.CA10,c.CA11,c.CA12,c.CA13,c.CA14,c.CA15,
		c.Cd_CC,c.Cd_SC,c.Cd_SS,c.TipAut,c.AutorizadoPor,
		a.Cd_TDI as Cd_TDIC, a.NDoc as NDocCli,
		v.Cd_TDI as Cd_TDIV, v.NDoc as NDocVdr
	from Cotizacion c
	left join Cliente2 a on a.RucE=c.RucE and a.Cd_Clt =c.Cd_Clt
	left join Vendedor2 v on v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
	where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
-- MM : 06/06/2011 : <Modificacion del sp : se agrego campos de autorizacion en el select>

GO

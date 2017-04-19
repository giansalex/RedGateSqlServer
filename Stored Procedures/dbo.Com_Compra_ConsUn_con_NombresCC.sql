SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_Compra_ConsUn_con_NombresCC]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
if not exists (select * from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
	Set @msj = 'No existe Compra'
else
begin
	select 	co.Cd_Com, co.Ejer, co.Prdo, co.RegCtb, Convert(nvarchar,co.FecMov,103) as FecMov, co.Cd_FPC, Convert(nvarchar,co.FecAPag,103) as FecAPag,
		co.Cd_TD,co.NroSre,co.NroDoc,Convert(nvarchar,co.FecED,103) as FecED, Convert(nvarchar,co.FecVD,103) as FecVD, co.Cd_Prv,p2.Cd_TDI as Cd_TDI_Prv,p2.NDoc as  NDoc_Prv,
		case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nomb_Prv,co.Cd_Area,
		co.Cd_CC, cc.Descrip as NomCC,
		co.Cd_SC,scc.Descrip as NomSC,
		co.Cd_SS,sscc.Descrip as NomSS,
		co.Cd_MR,co.Obs,co.BIM_S,co.IGV_S,co.BIM_E,co.IGV_E,co.BIM_C,co.IGV_C,co.Imp_N,co.Imp_O,co.Total,co.Cd_Mda,co.CamMda,
		co.Cd_MIS, MIS.Descrip as MtvoIngSal,co.Cd_OC,co.IB_Pgdo, co.IB_Anulado, co.DR_NCND, co.DR_NroDeT, co.DR_FecDet,co.DR_CdCom,co.DR_FecED,co.DR_CdTD,
		co.DR_NSre,co.DR_NDoc,co.CA01,co.CA02,co.CA03,co.CA04,co.CA05,co.CA06,co.CA07,co.CA08,co.CA09,co.CA10,
		co.CA11,co.CA12,co.CA13,co.CA14,co.CA15,co.CA16,co.CA17,co.CA18,co.CA19,co.CA20,
		co.CA21,co.CA22,co.CA23,co.CA24,co.CA25, dco.Cd_Alm, co.TipNC
	from 	Compra co 
		left join CCostos cc on co.RucE = cc.RucE and co.Cd_CC = cc.Cd_CC
		left join CCSub scc on co.RucE = scc.RucE and co.Cd_SC = scc.Cd_SC and scc.Cd_CC = cc.Cd_CC
		left join CCSubSub sscc on co.RucE = sscc.RucE and co.Cd_SS = sscc.Cd_SS and cc.Cd_CC = sscc.Cd_CC and scc.Cd_SC = sscc.Cd_SC
		left join Proveedor2 p2 on p2.Cd_Prv=co.Cd_Prv and p2.RucE=co.RucE
		left join MtvoIngSal MIS on MIS.Cd_MIS=co.Cd_MIS and co.RucE=MIS.RucE 
		left join CompraDet dco on co.Cd_Com=dco.Cd_Com and co.RucE=dco.RucE 
		
	where co.RucE=@RucE and co.Cd_Com=@Cd_Com
end
-- Leyenda --
-- JJ : 2010-08-24 : <Creacion del procedimiento almacenado>
-- MP : 2010-11-24 : <Modificacion del procedimiento almacenado>
-- MP : 2011-04-14 : <Modificacion del procedimiento almacenado> (MAS CAMPOS ADICIONALES)
-- CAM : 2011-11-07 : <Modificacion del procedimiento almacenado a nueva version(1)> (Se agrego la opcion de consultar TipNC)
-- exec Com_Compra_ConsUn_con_NombresCC '11111111111', 'CM00000468', null
/*

select * from Compra where RucE = '11111111111' and Cd_Com = 'CM00000468'
select * from CCostos where RucE = '11111111111'
select * from CCSub where RucE = '11111111111'
select * from CCSubSub where RucE = '11111111111'

*/
GO

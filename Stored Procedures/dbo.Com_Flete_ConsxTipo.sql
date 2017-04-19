SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_Flete_ConsxTipo]
@RucE nvarchar(11),
@NroMBL varchar(100),
@Tipo nvarchar(100),
@msj varchar(100) output
as

if(@Tipo = 'Naviera' or @Tipo = 'Agente')
begin
	select 	co.Cd_Com, co.Ejer, co.Prdo, co.RegCtb, Convert(nvarchar,co.FecMov,103) as FecMov, co.Cd_FPC, Convert(nvarchar,co.FecAPag,103) as FecAPag,
		co.Cd_TD,co.NroSre,co.NroDoc,Convert(nvarchar,co.FecED,103) as FecED, Convert(nvarchar,co.FecVD,103) as FecVD, co.Cd_Prv,p2.Cd_TDI as Cd_TDI_Prv,
		p2.NDoc as  NDoc_Prv,
		case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nomb_Prv,
		co.Cd_Area,co.Cd_CC,
		co.Cd_SC,co.Cd_SS,co.Cd_MR,co.Obs,co.BIM_S,co.IGV_S,co.BIM_E,co.IGV_E,co.BIM_C,co.IGV_C,co.Imp_N,co.Imp_O,co.Total,co.Cd_Mda,co.CamMda,
		co.Cd_MIS,MIS.Descrip as MtvoIngSal,co.Cd_OC,co.IB_Pgdo, co.IB_Anulado, co.DR_NCND, co.DR_NroDeT, co.DR_FecDet,co.DR_CdCom,co.DR_FecED,co.DR_CdTD,
		co.DR_NSre,co.DR_NDoc,co.CA01,co.CA02,co.CA03,co.CA04,co.CA05,co.CA06,co.CA07,co.CA08,co.CA09,co.CA10,
		co.CA11,co.CA12,co.CA13,co.CA14,co.CA15,co.CA16,co.CA17,co.CA18,co.CA19,co.CA20,
		co.CA21,co.CA22,co.CA23,co.CA24,co.CA25,dco.Cd_Alm
	from 	Compra co left join Proveedor2 p2 on p2.Cd_Prv=co.Cd_Prv and p2.RucE=co.RucE
		left join MtvoIngSal MIS on MIS.Cd_MIS=co.Cd_MIS and co.RucE=MIS.RucE 
		left join CompraDet dco on co.Cd_Com=dco.Cd_Com and co.RucE=dco.RucE 
	where co.RucE=@RucE and co.CA01=@NroMBL and CO.CA20 = @Tipo
end
else
begin
	select * from Venta
	where RucE=@RucE and CA01=@NroMBL
end


-- Leyenda --
-- MP : 2011-06-15 : <Creacion del porcedimiento almacenado> 
-- MP : 2011-10-26 : <Modificacion del porcedimiento almacenado> 
--exec Com_Compra_ConsUn '11111111111', 'CM00000099', null





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_CompraDetCons_explo2]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
select 	cd.Item,
		case(isnull(cd.Cd_Prod,'0')) when '0' then case(isnull(cd.Cd_Srv,'0')) when '0' then null else cd.Cd_Srv end else cd.Cd_Prod end as Cd_Prod,
		cd.Descrip,
		cd.ID_UMP,
		um.DescripAlt,		
		cd.Valor,
		cd.DsctoP,
		cd.DsctoI,
		cd.IMP,
		cd.IGV,
		cd.PU,
		cd.Cant,
		cd.Total,
		cd.Cd_CC,
		cd.Cd_SC,
		cd.Cd_SS,
		cd.Obs,
		cd.CA01,
		cd.CA02,
		cd.CA03,
		cd.CA04,
		cd.CA05,
		cd.CA06,
		cd.CA07,
		cd.CA08,
		cd.CA09,
		cd.CA10,
		cd.Cd_Alm,
		Alm.Nombre as Almacen,
		cd.Cd_Com from 	CompraDet cd left join Prod_UM um on cd.RucE=um.RucE and cd.ID_UMP = um.ID_UMP and cd.Cd_Prod = um.Cd_Prod left join Almacen Alm on Alm.Cd_Alm=cd.Cd_Alm and Alm.RucE=cd.RucE
where	cd.RucE=@RucE and cd.Cd_Com=@Cd_Com
print @msj
GO

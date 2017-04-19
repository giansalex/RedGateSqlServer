SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_CompraDetCons_explo3]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
select 	cd.Item,
		case(isnull(cd.Cd_Prod,'0')) when '0' then case(isnull(cd.Cd_Srv,'0')) when '0' then null else cd.Cd_Srv end else cd.Cd_Prod end as Cd_Prod,
		--p.CodCo1_ as CodCo ,
		case(IsNull(cd.Cd_Prod,'0')) when '0' then isnull(s.CodCo,'''') else isnull(p.CodCo1_,'''') end as CodCo,
		cd.Descrip,
		IsNull(cd.ID_UMP,'-'),
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
		IsNull(cd.Cd_Alm,'-'),
		um.Factor,
		cd.UsuModf,
		cd.FecMdf,
		Alm.Nombre as Almacen,
		cd.Cd_Com from 	CompraDet cd 
		left join producto2 p on cd.RucE=p.RucE and cd.Cd_Prod=p.Cd_Prod 
		left join Servicio2 s on cd.RucE=s.RucE and cd.Cd_Srv=s.Cd_Srv
		left join Prod_UM um on cd.RucE=um.RucE and cd.ID_UMP = um.ID_UMP and cd.Cd_Prod = um.Cd_Prod 
		left join Almacen Alm on Alm.Cd_Alm=cd.Cd_Alm and Alm.RucE=cd.RucE
where	cd.RucE=@RucE and cd.Cd_Com=@Cd_Com
print @msj

--exec Com_CompraDetCons_explo3 '11111111111','CM00001096',''
--exec Com_CompraDetCons_explo '11111111111','CM00001096',''
GO

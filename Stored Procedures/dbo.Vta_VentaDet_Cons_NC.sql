SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Vta_VentaDet_Cons_NC]
@RucE nvarchar(11),
@Cd_Vta nvarchar(20),
@msj varchar(100) output
---with encryption
as
select  cd.RucE,cd.Nro_RegVdt as Item, cd.Cd_Vta,
	case when isnull(cd.Cd_Prod,'')='' then cd.Cd_Srv else cd.Cd_Prod end as Cd_Item,
	case when isnull(cd.Cd_Prod,'')='' then '' else cd.Cd_Prod end as Cd_Prod,
	case when isnull(cd.Cd_Srv,'')='' then '' else cd.Cd_Srv end as Cd_Srv,
	case when isnull(pr.Nombre1,'')='' then '-' else pr.Nombre1 end as Nombre1,
	case when isnull(pr.CodCo1_,'')='' then '-' else pr.CodCo1_ end as CodVta,
	case when isnull(pu.DescripAlt,'')='' then '-' else pu.DescripAlt end as DescripAlt,
	case when isnull(cd.Descrip,'')='' then '-' else cd.Descrip end as Descrip,
	case when isnull(cd.IMP,.0)=.0 then .0 else cd.IMP end as IMP,
	case when isnull(cd.ID_UMP,0)=0 then 0 else cd.ID_UMP end as ID_UMP,
	case when isnull(cd.PU,.0)=.0 then .0 else cd.PU end as PU,
	0 as Pendiente,cd.Cant, cd.Valor, cd.DsctoP, cd.DsctoI,
	cd.IGV, case(isnull(cd.IGV,0)) when 0 then 0 else 1 end as IncIGV,
	cd.Total,cd.Cd_Alm,cd.Cd_IAV,cd.Cd_CC,cd.Cd_SC,cd.Cd_SS,pu.DescripAlt as UM,
	cd.Obs, cd.CA01, cd.CA02, cd.CA03, cd.CA04, cd.CA05, cd.CA06, cd.CA07, cd.CA08, cd.CA09, cd.CA10
from VentaDet cd left join Prod_UM pu on cd.RucE = pu.RucE and cd.Cd_Prod = pu.Cd_Prod and cd.ID_UMP = pu.ID_UMP
left join Producto2 pr on cd.RucE=pr.RucE and cd.Cd_Prod=pr.Cd_Prod where  cd.RucE =@RucE  and cd.Cd_Vta=@Cd_Vta

-- Leyenda --
-- MP : 2012-09-24 : <Creacion del procedimiento almacenado>
--select * from VentaDet where RucE = '11111111111'
--exec Vta_VentaDet_Cons '11111111111','VT00001223',null --NORSUR


GO

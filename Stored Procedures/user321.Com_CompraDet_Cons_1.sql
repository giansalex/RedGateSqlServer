SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE proc [user321].[Com_CompraDet_Cons_1]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
select  cd.RucE,cd.Item, cd.Cd_Com, cd.Cd_Prod, cd.Cd_Srv , cd.Descrip, cd.PU, cd.ID_UMP, pu.DescripAlt as UM , cd.Cant, cd.Valor, cd.DsctoP, cd.DsctoI,
	cd.IMP_New, cd.IGV_New, case(isnull(cd.IGV_New,0)) when 0 then 0 else 1 end as IncIGV, cd.Total, cd.Cd_Alm,cd.Cd_IA,cd.Cd_CC,cd.Cd_SC,cd.Cd_SS,
	cd.Obs, cd.CA01, cd.CA02, cd.CA03, cd.CA04, cd.CA05, cd.CA06, cd.CA07, cd.CA08, cd.CA09, cd.CA10
from CompraDet cd left join Prod_UM pu on cd.RucE = pu.RucE and cd.Cd_Prod = pu.Cd_Prod and cd.ID_UMP = pu.ID_UMP
where  cd.RucE = @RucE and cd.Cd_Com=@Cd_Com
GO

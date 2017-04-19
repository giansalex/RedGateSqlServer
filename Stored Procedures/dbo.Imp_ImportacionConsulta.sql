SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionConsulta]
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as

select * from (
select 
id.Cd_Com,
ItemCP as 'Item',
ItemCP,
p.Nombre1,
id.Cant, 
um.DescripAlt as 'UM',
id.PesoKg,
id.PesoKg * id.Cant as 'PesoKgT',
cd.IMP as 'EXW',
id.Exw as 'EXWT',
id.Com,
id.OtroE,
id.FOB,
id.Flete,
id.Seg,
id.OtroF,
id.CIF,
id.Adv,
id.OtroC,
id.Total,
id.CU,
id.Ratio,

cd.IMP as 'EXW_ME',
id.Exw_ME as 'EXWT_ME',
id.Com_ME,
id.OtroE_ME,
id.FOB_ME,
id.Flete_ME,
id.Seg_ME,
id.OtroF_ME,
id.CIF_ME,
id.Adv_ME,
id.OtroC_ME,
id.Total_ME,
id.CU_ME,
id.Ratio_ME
from ImportacionDet as id 
inner join Producto2 as p on id.RucE = p.RucE and id.Cd_Prod = p.Cd_Prod
inner join Prod_UM as um on id.RucE = um.RucE and id.Cd_Prod = um.Cd_Prod and id.ID_UMP = um.ID_UMP
inner join CompraDet as cd on id.RucE = cd.RucE and id.Cd_Com = cd.Cd_Com and  id.Cd_Prod = cd.Cd_Prod
where id.RucE = @RucE and id.Cd_IP = @Cd_IP
union all
select 
id.Cd_Com as 'Cd_Com',
count(ItemCp)+1 as 'Item',
null as 'ItemCP',
null as 'Nombre1',
null as 'Cant', 
null as 'UM',
null as 'PesoKg',
null as 'PesoKgT',
null as 'EXW',
sum(id.Exw) as 'EXWT',
sum(id.Com) as 'Com',
sum(id.OtroE) as 'OtroE',
sum(id.FOB) as 'FOB',
sum(id.Flete) as 'Flete',
sum(id.Seg) as 'Seg',
sum(id.OtroF) as 'OtroF',
sum(id.CIF) as 'CIF',
sum(id.Adv) as 'Adv',
sum(id.OtroC) as 'OtroC',
sum(id.Total) as 'Total',
null as 'CU',
sum(id.Total)/(sum(id.Exw)+sum(id.Com)) as 'Ratio',

null as 'EXW_ME',
sum(id.Exw) as 'EXWT_ME',
sum(id.Com) as 'Com_ME',
sum(id.OtroE) as 'OtroE_ME',
sum(id.FOB) as 'FOB_ME',
sum(id.Flete) as 'Flete_ME',
sum(id.Seg) as 'Seg_ME',
sum(id.OtroF) as 'OtroF_ME',
sum(id.CIF) as 'CIF_ME',
sum(id.Adv) as 'Adv_ME',
sum(id.OtroC) as 'OtroC_ME',
sum(id.Total) as 'Total_ME',
null as 'CU_ME',
sum(id.Total_ME)/(sum(id.Exw_ME)+sum(id.Com_ME)) as 'Ratio_ME'
from ImportacionDet as id 
where id.RucE = @RucE and id.Cd_IP = @Cd_IP
group by id.Cd_Com
union all
select 
id.Cd_Com as 'Cd_Com',
count(ItemCp)+2 as 'Item',
null as 'ItemCP',
null as 'Nombre1',
null as 'Cant', 
null as 'UM',
null as 'PesoKg',
null as 'PesoKgT',
null as 'EXW',
null as 'EXWT',
null as 'Com',
null as 'OtroE',
null as 'FOB',
null as 'Flete',
null as 'Seg',
null as 'OtroF',
null as 'CIF',
null as 'Adv',
null as 'OtroC',
null as 'Total',
null as 'CU',
null as 'Ratio',
null as 'EXW_ME',
null as 'EXWT_ME',
null as 'Com_ME',
null as 'OtroE_ME',
null as 'FOB_ME',
null as 'Flete_ME',
null as 'Seg_ME',
null as 'OtroF_ME',
null as 'CIF_ME',
null as 'Adv_ME',
null as 'OtroC_ME',
null as 'Total_ME',
null as 'CU_ME',
null as 'Ratio_ME'
from ImportacionDet as id 
where id.RucE = @RucE and id.Cd_IP = @Cd_IP
group by id.Cd_Com
union all
select 
'-' as 'Cd_Com',
count(*)+1 as 'Item',
null as 'ItemCP',
null as 'Nombre1',
null as 'Cant', 
null as 'UM',
null as 'PesoKg',
null as 'PesoKgT',
null as 'EXW',
sum(id.Exw) as 'EXWT',
sum(id.Com) as 'Com',
sum(id.OtroE) as 'OtroE',
sum(id.FOB) as 'FOB',
sum(id.Flete) as 'Flete',
sum(id.Seg) as 'Seg',
sum(id.OtroF) as 'OtroF',
sum(id.CIF) as 'CIF',
sum(id.Adv) as 'Adv',
sum(id.OtroC) as 'OtroC',
sum(id.Total) as 'Total',
null as 'CU',
sum(id.Total)/(sum(id.Exw)+sum(id.Com)) as 'Ratio',
null as 'EXW_ME',
sum(id.Exw) as 'EXWT_ME',
sum(id.Com) as 'Com_ME',
sum(id.OtroE) as 'OtroE_ME',
sum(id.FOB) as 'FOB_ME',
sum(id.Flete) as 'Flete_ME',
sum(id.Seg) as 'Seg_ME',
sum(id.OtroF) as 'OtroF_ME',
sum(id.CIF) as 'CIF_ME',
sum(id.Adv) as 'Adv_ME',
sum(id.OtroC) as 'OtroC_ME',
sum(id.Total) as 'Total_ME',
null as 'CU_ME',
sum(id.Total_ME)/(sum(id.Exw_ME)+sum(id.Com_ME)) as 'Ratio_ME'
from ImportacionDet as id 
where id.RucE = @RucE and id.Cd_IP = @Cd_IP
) as xD order by Cd_Com desc, Item
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImpPorcProdCons] 
@RucE nvarchar(11),
@Cd_IP char(7),
@ItemIC int,
@msj varchar(100) output
as
if not exists(select * from ImpPorcProd where RucE=@RucE and Cd_IP=@Cd_IP and ItemIC = @ItemIC)
	set @msj='Detalle de Importacion no existe'
else
begin
	select 
	id.RucE as 'RucE', 
	id.Cd_IP as 'Cd_IP',
	id.Item as 'Item',
	@ItemIC as 'ItemIC',
	isnull(pp.CstAsig,0) as 'CstAsig',
	isnull(pp.CstAsig_ME,0) as 'CstAsig_ME',
	isnull(pp.PorcAsig,0) as 'PorcAsig',
	case(isnull(pp.RucE,0)) when '0' then '0' else '1' end as 'Check',
	id.EXW/id.Cant as 'CU',
	id.EXW_ME/id.Cant as 'CU_ME',
	pum.Volumen as 'Volumen',
	pum.PesoKg as 'PesoKg',
	id.Cant as 'Cant',
	id.Cd_Com as 'Cd_Compra',
	id.ItemCP as 'ItemCP',
	id.Cd_Prod as 'Cd_Prod',
	id.ID_UMP as 'ID_UMP',
	p.Nombre1 as 'ProdNom',
	p.Descrip as 'ProdDescrip',
	um.Nombre as 'UMPNom',
	pum.DescripAlt as 'UMPDescrip'
	from ImportacionDet as id 
	left join ImpPorcProd as pp on id.RucE = pp.RucE and id.Cd_IP = pp.Cd_IP and id.Item = pp.Item and pp.ItemIC = @ItemIC
	inner join Producto2 as p on id.RucE = p.RucE and id.Cd_Prod = p.Cd_Prod
	inner join Prod_UM as pum on id.RucE = pum.RucE and id.Cd_Prod = pum.Cd_Prod and id.ID_UMP = pum.ID_UMP
	inner join UnidadMedida as um on pum.Cd_UM = um.Cd_UM
	where id.RucE=@RucE and id.Cd_IP=@Cd_IP
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompraDet_Cons_3]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
--with encryption
as
select oc.RucE, oc.Item, ISNULL(oc.Cd_Prod,oc.Cd_SRV) as Cd_ProdSrv, isnull(p.CodCo1_,s.CodCo) as CodCom, 
isnull(p.Nombre1,s.Nombre) as NombreProdServ, pum.ID_UMP, isnull(pum.DescripAlt,'-') as DescripAlt,isnull(oc.Cd_Alm,'-') as Cd_Alm,oc.Valor, isnull(oc.DsctoP,'0.000') as DsctoP, isnull(oc.DsctoI,'0.000') as DsctoI,oc.BIM,oc.IGV,oc.PU,oc.Cant,oc.Total, isnull(oc.Obs,'-') as Obs
from OrdCompraDet oc
left join Producto2 p on p.RucE = oc.RucE and p.Cd_Prod = oc.Cd_Prod 
left join Servicio2 s on s.RucE = oc.RucE and s.Cd_Srv = oc.Cd_SRV
left join Prod_UM pum on pum.RucE = oc.RucE and pum.Cd_Prod = oc.Cd_Prod and pum.ID_UMP = oc.ID_UMP
where oc.RucE = @RucE and oc.Cd_OC = @Cd_OC 

--	LEYENDA
--	CAM 25/03/2012 creación. EL otro SP estaba muy complicado.

--	PRUEBAS
--	exec Com_OrdCompraDet_Cons_3 '20102028687','OC00000007',null
	
GO

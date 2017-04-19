SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ConsOPDetalle_ParaOC]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as
select  opd.RucE, Item, opd.Cd_Prod, opd.Cd_Srv, opd.ID_UMP, pu.DescripAlt 'UnidadMedida', 
		Cant, ISNULL(p.Nombre1, s.Nombre) 'NombreDetalle', p.Descrip 'Descripcion'
from OrdPedidoDet opd
left join Producto2 p on opd.RucE=p.RucE and opd.Cd_Prod=p.Cd_Prod
left join Servicio2 s on opd.RucE=s.RucE and opd.Cd_Srv=s.Cd_Srv
left join Prod_UM pu on opd.RucE=pu.RucE and opd.Cd_Prod=pu.Cd_Prod and opd.ID_UMP=pu.ID_UMP
where opd.RucE = @RucE and opd.Cd_OP = @Cd_OP
GO

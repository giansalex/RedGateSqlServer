SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdOPCons]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as
if not exists (select * from OrdPedidoDet where RucE = @RucE and Cd_OP = @Cd_OP)
	set @msj = 'No existe detalle en la orden de produccion'
else
begin
	select distinct op.Cd_Prod, p.Nombre1, p.Descrip, um.Nombre, pum.DescripAlt, op.ID_UMP, op.Cant from OrdPedidoDet op
	inner join Formula f on f.RucE=op.RucE and f.Cd_Prod=op.Cd_Prod and f.ID_UMP=op.ID_UMP
	inner join Producto2 p on p.RucE=op.RucE and p.Cd_Prod=op.Cd_Prod
	inner join Prod_UM pum on pum.RucE=op.RucE and pum.Cd_Prod=op.Cd_Prod and pum.ID_UMP=op.ID_UMP
	inner join UnidadMedida um on um.Cd_UM = pum.Cd_UM 
	where op.RucE=@RucE and op.Cd_OP=@Cd_OP
end
-- Leyenda --
-- FL : 11/03/2011 : <Creacion del procedimiento almacenado>
-- exec Inv_ProdOPCons '11111111111','OP00000056',null
GO

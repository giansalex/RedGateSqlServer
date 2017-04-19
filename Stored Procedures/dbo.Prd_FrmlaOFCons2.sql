SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Prd_FrmlaOFCons2]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from FrmlaOF where Cd_OF=@Cd_OF and RucE = @RucE)
	set @msj = 'Formula Orden de Fabricacion no existe'
else	
	select  p.Nombre1,u.DescripAlt, f.*, o.Cant as CantProd,p.CodCo1_ as Cd_Comer from FrmlaOF f 
		inner join Producto2 p on p.RucE=f.RucE and p.Cd_Prod=f.Cd_Prod
		inner join Prod_UM u on u.RucE=f.RucE and u.Cd_Prod=f.Cd_Prod and u.ID_UMP=f.ID_UMP
		inner join OrdFabricacion o on o.RucE=f.RucE and o.Cd_OF=f.Cd_OF
		where f.RucE = @RucE and f.Cd_OF=@Cd_OF
print @msj


--exec Prd_FrmlaOFCons2 '11111111111','OF00000006',null
--LEYENDA-- 
--FL: 03/03/2011 <Creacion del procedimiento almacenado>

--select * from producto2 where ruce='11111111111'
GO

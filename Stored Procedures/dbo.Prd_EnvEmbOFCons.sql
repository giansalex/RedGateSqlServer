SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_EnvEmbOFCons]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from EnvEmbOF where Cd_OF=@Cd_OF and RucE = @RucE)
	set @msj = 'Envases y Embalajes No existe'
else	
	select p.Nombre1,u.DescripAlt,e.* from EnvEmbOF e
	inner join Producto2 p on p.RucE=e.RucE and p.Cd_Prod=e.Cd_Prod
	inner join Prod_UM u on u.RucE=e.RucE and u.Cd_Prod=e.Cd_Prod and u.ID_UMP=e.ID_UMP
	where e.Cd_OF=@Cd_OF and e.RucE = @RucE
print @msj

--LEYENDA-- 
--FL: 03/03/2011 <Creacion del procedimiento almacenado >
GO

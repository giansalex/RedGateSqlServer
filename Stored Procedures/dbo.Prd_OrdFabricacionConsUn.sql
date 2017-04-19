SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_OrdFabricacionConsUn]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from OrdFabricacion where Cd_OF=@Cd_OF and RucE = @RucE)
	set @msj = 'Orden de Fabricacion no existe'
else	
	select * from OrdFabricacion
	where Cd_OF=@Cd_OF and RucE = @RucE
	
print @msj

--LEYENDA--
--FL: 03/03/2011 <Creacion del procedimiento almacenado>
--select Cd_CC,Cd_SC,Cd_SS from OrdFabricacion where RucE = '11111111111' and Cd_OF = 'OF00000062'
GO

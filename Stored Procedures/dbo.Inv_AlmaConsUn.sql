SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaConsUn]
@RucE nvarchar(11),
@Cd_Alm varchar(20),
@msj varchar(100) output
as
if not exists (select * from Almacen where RucE= @RucE  and Cd_Alm=@Cd_Alm)
	set @msj = 'Inventario no existe.'
else	select * from Almacen where RucE= @RucE  and  Cd_Alm=@Cd_Alm 
print @msj

-- Leyenda --
-- PP : 2010-02-12 : <Creacion del procedimiento almacenado>

--exec Inv_AlmaConsUn '11111111111','A00',''
GO

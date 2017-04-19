SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2ConsUn]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
if not exists (select * from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv)
	set @msj = 'Proveedor no existe'
else	select * from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv
print @msj

-- Leyenda --
-- PP : 2010-02-18 : <Creacion del procedimiento almacenado>



GO

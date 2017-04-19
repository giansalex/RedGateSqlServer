SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_ProveedorCons_Direc]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as

select Direc from Proveedor2 where RucE = @RucE and Cd_Prv = @Cd_Prv

-- Leyenda --
-- DI : 2012-04-09 : <Creacion del procedimiento almacenado>
GO

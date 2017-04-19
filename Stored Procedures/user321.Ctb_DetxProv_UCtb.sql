SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Ctb_DetxProv_UCtb]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as

	if not exists (select top 1 *from CptoDetxProv where RucE=@RucE and Cd_Prv=@Cd_Prv)
		set @msj='No existen Detracciones para el proveedor'
	else
	begin
		update CptoDetxProv set IB_Ctb=0 
		where RucE=@RucE and Cd_Prv=@Cd_Prv
	end
-- Leyenda --
--JJ 09/02/2011 <Creacion del procedimiento almacenado
GO

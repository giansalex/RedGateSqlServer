SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Ctb_DetxProvMdf]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_CDtr char(4),
@Cd_CDtrAnt char(4),
@IB_Ctb bit,
@msj varchar(100) output
as

	if not exists (select top 1 *from CptoDetxProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_CDtr=@Cd_CDtr)
		set @msj='Detraccion por Proveedor no existe'
	else
	begin
		update CptoDetxProv set Cd_CDtr=@Cd_CDtr, IB_Ctb=@IB_Ctb
		where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_CDtr=@Cd_CDtrAnt
	end
-- Leyenda --
-- JJ 09/02/2011 <Creacion del procedimiento almacenado>


GO

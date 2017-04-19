SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Ctb_DetxProvElim]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_CDtr char(4),
@msj varchar(100) output
as

	if not exists (select top 1 *from CptoDetxProv  where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_CDtr=@Cd_CDtr)
		set @msj='No existe detraccion'
	else 
	begin
	delete CptoDetxProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_CDtr=@Cd_CDtr
	end
GO

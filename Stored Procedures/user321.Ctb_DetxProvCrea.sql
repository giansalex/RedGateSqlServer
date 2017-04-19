SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [user321].[Ctb_DetxProvCrea]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_CDtr char(4),
@IB_Ctb bit,
@msj varchar(100) output
as

	if exists (select top 1 *from CptoDetxProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_CDtr=@Cd_CDtr)
		set @msj='Concepto de Detraccion ya fue asignado anteriormente'
	else
	begin
		insert into CptoDetxProv(RucE,Cd_Prv,Cd_CDtr,IB_Ctb) values(@RucE,@Cd_Prv,@Cd_CDtr,@IB_Ctb)
	end
-- Leyenda --
--JJ 09/02/2011 : <Creacion del procedimiento almacenado>
GO

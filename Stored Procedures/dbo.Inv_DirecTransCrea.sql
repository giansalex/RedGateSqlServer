SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_DirecTransCrea]
@RucE nvarchar(11),
@Cd_Tra char(7),
@Item int,
@Direc varchar(100),
@obs varchar(200),
@Estado bit,
--@Estado bit,
@msj varchar(100) output
as

begin transaction
	insert into DirecTrans(RucE,Cd_Tra,Item,Direc,obs,Estado)
	              values(@RucE,@Cd_Tra,@Item,@Direc,@obs,1)
	if @@rowcount <= 0
	begin	   
	   set @msj = 'Direccion no pudo ser creada'
	   rollback transaction
	   return
	end
commit transaction



GO

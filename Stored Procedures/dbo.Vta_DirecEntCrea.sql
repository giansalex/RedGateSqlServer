SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_DirecEntCrea]
@RucE nvarchar(11),
@Cd_Clt char(10),
@Direc varchar(100),
@obs varchar(200),
@porDefecto bit = 0,
--@Estado bit,
@msj varchar(100) output
as

begin transaction
declare @Item int
	if(@porDefecto = 1)
	begin
		update DirecEnt set PorDefecto = 0 where RucE = @RucE And Cd_Clt = @Cd_Clt
	end
	set @Item = (select dbo.Item(@RucE,@Cd_Clt))
	insert into DirecEnt(RucE,Cd_Clt,Item,Direc,obs,Estado,PorDefecto)
	              values(@RucE,@Cd_Clt,@Item,@Direc,@obs,1,@porDefecto)
	if @@rowcount <= 0
	begin	   
	   set @msj = 'Direccion no pudo ser creada'
	   rollback transaction
	   return
	end
commit transaction
print('Se modificó el procedimiento almacenado Vta_DirecEntCrea')
GO

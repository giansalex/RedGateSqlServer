SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasElim]
@RucE nvarchar(11),
@Ejer varchar(4),
@NroCta nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Cuenta no existe'
else
if exists (select NroCta from voucher where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Cuenta posee movimientos. Imposible eliminar'
else
begin
	begin transaction
	exec Ctb_AmarreCtaElim_X_Cta1 @RucE,@NroCta,@Ejer,null
	delete from PlanCtas
	where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer

	if @@rowcount <= 0
	begin
	   set @msj = 'Cuenta no pudo ser eliminado'
	   rollback transaction
	end
	commit transaction
end
print @msj

----------------------PRUEBA------------------------
--exec Ctb_PlanCtasElim '11111111111','2009','14.1.0.06',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--PV: Mdf: Mar 23/03/2010 -- Se valido que cta no tenga movimientos para ser eliminada
--FL: 17/09/2010 <se agrego ejercicio>



GO

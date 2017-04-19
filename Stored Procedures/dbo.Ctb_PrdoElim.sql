SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PrdoElim]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if exists (select top 1 Ejer from Voucher where RucE=@RucE and Ejer=@Ejer)
begin
	Set @msj = 'Existe informacion vinculada'
	return
end
if not exists (select * from Periodo where RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Ejercicio no existe'
else
begin
	delete from Asiento where RucE=@RucE and Ejer=@Ejer
	delete from AmarreCta where RucE=@RucE and Ejer=@Ejer
	delete from PlanCtasDef where RucE=@RucE and Ejer=@Ejer
	delete from PlanCtas where RucE=@RucE and Ejer=@Ejer
	
	delete from Periodo where RucE=@RucE and Ejer=@Ejer
	if @@rowcount <= 0
	   set @msj = 'Ejercicio no pudo ser modificado'
end
print @msj

--MP : 02/01/2012 : <Modificacion del procedimiento almacenado>
GO

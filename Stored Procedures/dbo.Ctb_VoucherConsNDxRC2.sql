SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherConsNDxRC2] -- De un Auxiliar --> SE CREO POR LA PURAS (Esta de mas mandar Cd_Aux, xq el RegCtb es unico para c/Emp en un año)
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@Cd_Aux nvarchar(10),
@msj varchar(100) output
as



if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	Set @msj = 'No existe voucher con el registro contable '+@RegCtb 
else

if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb and ( Cd_Clt=@Cd_Aux or Cd_Prv=@Cd_Aux) /*Cd_Aux=@Cd_Aux*/)
	Set @msj = 'Existe voucher con el registro contable '+@RegCtb + ' pero no pertenece a este auxiliar'

else
begin
	select top 1 /*convert(char(10),FecED,103) as*/ FecED,
	Cd_TD,
	NroSre,
	NroDoc	
	from Voucher
	where RucE=@RucE and RegCtb=@RegCtb and ( Cd_Clt=@Cd_Aux or Cd_Prv=@Cd_Aux) /*Cd_Aux=@Cd_Aux*/ and NroDoc is not null 
end

print @msj

/*
J -> CREADO 23/09/2009 DOCUMENTO DE REFERENCIA
PV: LUN 05/10/2009 Mdf: retornaba nro docs null
PV: LUN 05/10/2009 Creado: se agrego campo Cd_Aux
PV: MAR 17/08/2010 Mdf: Se mejoro mensajes (si sirve Cd_Aux si es que se quiere validar la correspodenicia de un RegCtb a un Auxiliar. Ejm. Caso Nota de credito -- Factura)
CAM: JUE 16/09/2010 Mdf:Se modifico para que compare codigo de Cliente o del Proveedor
*/
GO

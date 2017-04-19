SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_EmpElim]
@Ruc nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Empresa Where Ruc=@Ruc)
	set @msj = 'Empresa no existe'
else 
begin	


	delete from AccesoE Where RucE=@ruc
	delete from Periodo Where RucE=@ruc
	delete from Area Where RucE=@ruc
	delete from Banco Where RucE=@ruc
	delete from preciosrv Where RucE=@ruc
-- (*1) GC2016 PV: Agregado el 24/04/2016	
	delete from ConceptoDetracHist Where RucE=@ruc
	delete from ConceptosDetrac Where RucE=@ruc
	delete from Producto2 Where RucE=@ruc
-- Fin (*1)
	delete from Servicio2 Where RucE=@ruc
	delete from ccsubsub Where RucE=@ruc
    delete from ccsub Where RucE=@ruc
    delete from CCostos Where RucE=@ruc
	delete from planctasdef Where RucE=@ruc
	delete from planctas Where RucE=@ruc
	delete from asiento Where RucE=@ruc
	delete from mtvoingsal Where RucE=@ruc
	delete from Empresa Where Ruc=@ruc
	
	
	if @@rowcount <= 0
		set @msj = 'Empresa no pudo ser eliminado'
	else
	begin
		--Eliminando los campos fijos de la empresa:
		Delete from VentaCfg where RucE=@Ruc
	end
end
print @msj
--PV  -->  Lun10/11/08
--DE  -->  Vie 26/12/08
--EF  -->  Lun 18/02/13
GO

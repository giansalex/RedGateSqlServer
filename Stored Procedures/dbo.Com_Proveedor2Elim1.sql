SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Elim1]
@RucE nvarchar(11),
@Cd_Prv char(7),

@msj varchar(100) output
as
	if not exists (select * from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv)
	set @msj = 'Proveedor no existe'

	else if exists (select * from SCxProv where RucE=@RucE and  Cd_Prv=@Cd_Prv)
	begin
		set @msj='No puede eliminar Proveedor porque ha sido registrado en alguna Solicitud de Compras'
		
	end
	else if exists (select * from Compra where RucE=@RucE and  Cd_Prv=@Cd_Prv)
	begin
		set @msj='No puede eliminar Proveedor porque ha sido registrado en alguna Compra'
		
	end
	else if exists (select * from Voucher where RucE=@RucE and  Cd_Prv=@Cd_Prv)
	begin
		set @msj='No puede eliminar Proveedor porque tiene informaciÃ³n registrada en voucher'	
	end
	else if exists (select * from prodprov where RucE=@RucE and Cd_Prv=@Cd_Prv)
	begin
		delete from ProdProvPrecio where RucE=@RucE and Cd_Prv=@Cd_Prv
		delete from ProdProv where RucE = @RucE and Cd_Prv=@Cd_Prv
	end
	else
	begin
	begin transaction
		delete from Contacto where Cd_Prv=@Cd_Prv
		delete from Proveedor2 
		where RucE=@RucE and Cd_Prv=@Cd_Prv
		if @@rowcount <= 0
		begin	   set @msj = 'Proveedor no pudo ser eliminado'
		   rollback transaction
		end
	commit transaction
	end
	print @msj


-- Leyenda --
-- PP : 2010-02-18 : <Creacion del procedimiento almacenado>

GO

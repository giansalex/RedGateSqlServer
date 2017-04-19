SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompraElim]
@RucE nvarchar(11),
@Cd_OC char(10),
@UsuCrea varchar(15),
@msj varchar(100) output
as
	if not exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC)
	begin
		set @msj = 'Orden de Compra no existe'
	end
	else if exists (select *from Compra where RucE=@RucE and Cd_OC=@Cd_OC)
	begin
		set @msj='Orden de Compra tiene Compra Relacionada'
		
	end
	else if exists (select *from inventario where Cd_OC=@Cd_OC and RucE=@RucE)
	begin
		set @msj='Orden de Compra tiene Inventario Relacionado'
		
	end	
	else if(@UsuCrea!= (select UsuCrea from OrdCompra Where Ruce=@RucE and Cd_OC=@Cd_OC))
	begin
		set @msj = 'No puede eliminar la Orden de Compra creada por otro usuario'
	end
	else
	begin
		begin transaction
		
		delete from OrdCompraDet where RucE=@RucE and Cd_OC=@Cd_OC 
		delete from OrdCompra
		where RucE=@RucE and Cd_OC=@Cd_OC
		if @@rowcount <= 0
		begin	   
			set @msj = 'Orden de Compra no pudo ser eliminado'
	   		rollback transaction
		end
		exec Gfm_ContactoxDocumento_EliminarxCodigo @RucE,@Cd_OC,''
		commit transaction
	end

print @msj

-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>
-- JJ :  2010-08-06 : <Modificacion del Procedimiento Almacenado>
--J :  2011-01-05 : <Modificacion del Procedimiento Almacenado>
--exec dbo.Com_OrdCompraElim '11111111111','OC00000001','jesus',null

GO

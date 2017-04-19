SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherDRElim]
@RucE nvarchar(11),
@Cd_Vou int,
@msj varchar(100) output
as
if not exists (select * from VoucherDR where RucE=@RucE and Cd_Vou=@Cd_Vou)
	set @msj = 'Voucher no existe'
else
begin
	begin
		if exists (select * from VoucherDR where RucE=@RucE and Cd_Vou=@Cd_Vou)
		begin
			set @msj = 'Documento Referencia no puede ser eliminada por estar enlazada a informacion de voucher'
			return
		end
		
		delete VoucherRD Where RucE=@RucE and Cd_Vou=@Cd_Vou
		
		if @@rowcount <= 0
			set @msj = 'Documento Referencia no pudo ser eliminado'
	end
end
print @msj
GO

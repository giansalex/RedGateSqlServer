SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjePagoElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Cnj char(10),
@msj varchar(100) output

AS

if not exists (Select * From CanjePago Where RucE=@RucE and Ejer=@Ejer and Cd_Cnj=@Cd_Cnj)
	Set @msj = 'Operacion '+@Cd_Cnj+' no existe'
else
begin
begin transaction

	Declare @RegCtb nvarchar(15)
	Set @RegCtb=(Select RegCtb From CanjePago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)

	delete from CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
	delete from Letra_Pago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
	delete from CanjePago where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Ejer=@Ejer
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al eliminar operacion '+@Cd_Cnj
		rollback transaction
		return
	end
	
	delete from Voucher Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	
commit transaction	
end

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>

GO

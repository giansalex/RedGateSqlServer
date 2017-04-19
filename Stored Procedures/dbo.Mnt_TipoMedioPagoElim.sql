SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Mnt_TipoMedioPagoElim]
@Cd_TMP char(3),
@msj varchar(100) output
as
if not exists (select * from MedioPago where Cd_TMP=@Cd_TMP)
	set @msj = 'Tipo de Medio de Pago no existe'
else
begin
	delete from MedioPago where Cd_TMP=@Cd_TMP
	
	if @@rowcount <= 0
	set @msj = 'Tipo de Medio de Pago no pudo ser eliminado'	
end
print @msj

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Mnt_TipoMedioPagoMdf]
@Cd_TMP char(3),
@Descrip varchar(50),
@NomCorto varchar(5),
@Estado bit,
@IC_IE char,
@msj varchar(100) output
as
if not exists (select * from MedioPago where Cd_TMP=@Cd_TMP)
	set @msj = 'Tipo de Medio de Pago no existe'
else
begin
	update MedioPago set NomCorto=@NomCorto, Descrip=@Descrip, 
                         Estado=@Estado, IC_IE =@IC_IE
	where Cd_TMP=@Cd_TMP
	
	if @@rowcount <= 0
		set @msj = 'Tipo de Medio de Pago no pudo ser modificado'	
end
print @msj

--select * from MedioPago where Cd_TMP='109'
GO

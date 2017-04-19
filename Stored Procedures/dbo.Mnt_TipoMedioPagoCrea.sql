SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Mnt_TipoMedioPagoCrea]
@Descrip varchar(200),
@NomCorto varchar(10),
@IC_IE char(1),
@Cd_TMP char(3) output,
@msj varchar(100) output
as
if exists (select * from MedioPago where Descrip = @Descrip and NomCorto = @NomCorto)
	set @msj = 'Ya existe un medio de pago con el nombre ['+@Descrip+']'
else
begin
	set @Cd_TMP = user123.Cod_TMP()
	insert into MedioPago(Cd_TMP,Descrip,NomCorto,IC_IE,Estado)
		   Values(@Cd_TMP,@Descrip,@NomCorto,@IC_IE,1)
	
	if @@rowcount <= 0
	set @msj = 'Tipo de Medio de Pago no pudo ser registrado'	
end
print @msj
--cam : 25-08-2012 : <Modificacion del procedimiento almacenado>
GO

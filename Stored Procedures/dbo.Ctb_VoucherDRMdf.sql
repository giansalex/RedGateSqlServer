SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherDRMdf]
@RucE nvarchar(11),
@Cd_Vou int,
@FecED smalldatetime,
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
--@Estado bit,
@msj varchar(100) output
as
if not exists (select * from VoucherDR where RucE=@RucE and Cd_Vou=@Cd_Vou)
	set @msj = 'No existe Voucher'
else
begin
	begin
		update VoucherDR set FecED=@FecED, Cd_TD=@Cd_TD, NroSre=@NroSre, NroDoc=@NroDoc--, Estado=@Estado
		where RucE=@RucE and Cd_Vou=@Cd_Vou
	
		if @@rowcount <= 0
		   set @msj = 'Documento Referencia de Voucher no pudo ser modificado'
	end
end
print @msj

-- Leyenda --

--DI: Jue 12/11/09 Modificacion colocar el proceso de verificacion de cierre de periodo (en este momento se encuentra bloqueado)
GO

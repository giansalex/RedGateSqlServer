SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanAsig]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vou int,
@IB_Conc bit,
@msj varchar(100) output
as
begin
	Update Voucher Set IB_Conc=@IB_Conc where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al realizar asignacion'
	end
end
print @msj
GO

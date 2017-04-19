SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanAsig2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vou int,
@IB_Conc bit,
@FecConc smalldatetime,
@msj varchar(100) output
as
begin

	if(@IB_Conc = 0)
		Set @FecConc = null

	Update Voucher Set IB_Conc=@IB_Conc, FecConc=@FecConc where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou

	if @@rowcount <= 0
	begin
		Set @msj = 'Error al realizar asignacion'
	end
end
print @msj
GO

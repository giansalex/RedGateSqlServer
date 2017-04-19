SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Cod_Vou](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(Cd_Vou) from Voucher where RucE=@RucE

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Cd_Vou) from Voucher where RucE=@RucE
	set @n = @n+1
	end
      return @n
end





GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_Precio](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(ID_Prec) from Precio where RucE=@RucE

      if @n=0
	set @n=1
      else
	begin
	select @n=max(ID_Prec) from Precio where RucE=@RucE
	set @n = @n+1
	end
      return @n
end


GO

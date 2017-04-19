SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Cod_Psp](@RucE nvarchar(11))
returns nvarchar(8) AS
begin 
      declare @c nvarchar(8), @n int
      select @c = count(Cd_Psp) from Presupuesto where RucE=@RucE
      if @c=0
	set @c='00000001'
      else
	begin
	select @c=max(Cd_Psp) from Presupuesto where RucE=@RucE
	--set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c =right('00000000'+ltrim(str(@n)), 8)
	end
       return @c
end



GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_CC](@RucE nvarchar(11))
returns nvarchar(4) AS
begin 
      declare @c nvarchar(4), @n int
      select @c = count(Cd_CC) from CCostos where RucE=@RucE
      if @c=0
	set @c='0001'
      else
	begin
	select @c=max(Cd_CC) from CCostos where RucE=@RucE
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('0000'+ltrim(str(@n)), 4 )
	end
       return @c

end



GO

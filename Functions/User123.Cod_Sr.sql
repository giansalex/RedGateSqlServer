SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Sr](@RucE nvarchar(11))
returns nvarchar(4) AS
begin 
      declare @c nvarchar(4), @n int
      select @c = count(Cd_Sr) from Serie where RucE=@RucE
      if @c=0
	set @c='S001'
      else
	begin
	select @c=max(Cd_Sr)from Serie where RucE=@RucE
	set @c= right(@c,3)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'S'+right('000'+ltrim(str(@n)), 3)
	end
       return @c

end








GO

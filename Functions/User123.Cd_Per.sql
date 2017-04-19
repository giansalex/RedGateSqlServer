SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_Per](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Per) from PersonaRef where RucE=@RucE
      if @c=0
	set @c='PER0001'
      else
	begin
	select @c=max(Cd_Per) from PersonaRef where RucE=@RucE
	set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'PER'+right('0000'+ltrim(str(@n)), 4)
	end
       return @c

end
GO

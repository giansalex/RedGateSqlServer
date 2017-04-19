SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_CGV](@RucE nvarchar(11))
returns nvarchar(3) AS
begin 
      declare @c nvarchar(3), @n int
      select @c = count(Cd_CGV) from ComisionGrupVdr where RucE=@RucE
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_CGV) from ComisionGrupVdr where RucE=@RucE
	--set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3)
	end
       return @c

end


GO

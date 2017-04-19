SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_SCoEnv](@RucE nvarchar(11))
returns nvarchar(5) AS
begin 
      	declare @c int, @n int
      	select @c = count(Cd_SCoEnv) from SCxProv where RucE=@RucE 
      	if @c=0
		set @c=1
      	else
	begin
		select @c=max(Cd_SCoEnv) from SCxProv where RucE=@RucE 
	--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	--	set @n =convert(int, @c)+1
	--	set @c = right('0000'+ltrim(str(@n)), 4 )
		set @c = @c + 1
	end
       	return @c

end
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_SC](@RucE nvarchar(11), @Cd_CC nvarchar(4))
returns nvarchar(4) AS
begin 
      declare @c nvarchar(4), @n int
      select @c = count(Cd_SC) from CCSub where RucE=@RucE and Cd_CC=@Cd_CC
      if @c=0
	set @c='0001'
      else
	begin
	select @c=max(Cd_SC) from CCSub where RucE=@RucE and Cd_CC=@Cd_CC
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('0000'+ltrim(str(@n)), 4 )
	end
       return @c

end








GO

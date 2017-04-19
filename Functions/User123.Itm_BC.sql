SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Itm_BC](@RucE nvarchar(11))
returns nvarchar(11) AS
begin 
      declare @c nvarchar(10), @n int
      select @c = count(Itm_BC) from Banco where RucE=@RucE
      if @c=0
	set @c='BC00000001'
      else
	begin
	select @c=max(Itm_BC) from Banco where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'BC'+right('00000000'+ltrim(str(@n)), 8)
	end
       return @c
end


GO

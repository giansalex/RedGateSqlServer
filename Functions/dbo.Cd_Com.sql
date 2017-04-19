SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_Com](@RucE nvarchar(11))
returns char(10) AS
begin 
      declare @c nvarchar(10), @n int
      select @c = count(Cd_Com) from Compra where RucE=@RucE
      if @c=0
	set @c='CM00000001'
      else
	begin
	select @c=max(Cd_Com) from Compra where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'CM'+right('00000000'+ltrim(str(@n)), 8)
	end
       return @c

end

GO

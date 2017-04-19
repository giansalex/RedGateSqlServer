SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_SP](@RucE nvarchar(11))
returns char(6) AS
begin 
      declare @c char(6), @n int
      select @c = count(Cd_SP) from ServProv where RucE=@RucE
      if @c=0
	set @c='SP0001'
      else
	begin
	select @c=max(Cd_SP) from ServProv where RucE=@RucE
	set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'SP'+right('0000'+ltrim(str(@n)), 4)
	end
       return @c

end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_IP](@RucE nvarchar(11))
returns char(7) AS
begin 
      declare @c char(7), @n int
      select @n = count(*) from Importacion where RucE=@RucE
      if @n=0
	set @c='IP00001'
      else
	begin
	select @c=max(Cd_IP) from Importacion where RucE=@RucE
	set @c= right(@c,5)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'IP'+right('0000000'+ltrim(str(@n)), 5)
	end
       return @c
end
GO

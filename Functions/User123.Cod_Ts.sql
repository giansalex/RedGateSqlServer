SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Ts]()
returns nvarchar(3) AS
begin 
      declare @c nvarchar(3), @n int
      select @c = count(Cd_Ts) from Tasas
      if @c=0
	set @c='T01'
      else
	begin
	select @c=max(Cd_Ts) from Tasas
	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'T'+right('00'+ltrim(str(@n)), 2)
	end
       return @c
end
GO

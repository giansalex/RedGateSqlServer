SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Rb]()
returns nvarchar(4) AS
begin 
      declare @c nvarchar(4), @n int
      select @c = count(Cd_Rb) from RubrosRpt
      if @c=0
	set @c='0001'
      else
	begin
	select @c=max(Cd_Rb)from RubrosRpt
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('0000'+ltrim(str(@n)), 4 )
	end
       return @c

end


GO

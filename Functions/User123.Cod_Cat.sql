SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Cat]()
returns nvarchar(2) AS
begin 
      declare @c nvarchar(2), @n int
      select @c = count(Cd_Cat) from Categoria
      if @c=0
	set @c='01'
      else
	begin
	select @c=max(Cd_Cat)from Categoria
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('00'+ltrim(str(@n)), 2)
	end
       return @c
end



GO

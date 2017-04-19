SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_TMP]()
returns nvarchar(3) AS
begin 
      declare @c char(3), @n int
      select @c = count(Cd_TMP) from MedioPago where Cd_TMP != '999'
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_TMP)from MedioPago where Cd_TMP != '999'
	--print @c
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right(''+ltrim(str(@n)), 3)
	end
       return @c
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_TipoExistencia]()
returns char(2) AS
begin 
      declare @c char(2), @n int
      select @c = count(Cd_TE) from TipoExistencia
      if @c=0
	set @c='01'
      else
	begin
	select @c=max(Cd_TE)from TipoExistencia
	set @n =convert(int, @c)+1
	set @c = right('00'+ltrim(str(@n)), 2)
	end
       return @c
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_TO]()
returns nvarchar(2) AS
begin 
      declare @c nvarchar(2), @n int
      select @c = count(Cd_TO) from TipoOperacion
      if @c=0
	set @c='01'
      else
	begin
	select @c=max(Cd_TO) from TipoOperacion
	set @n =convert(int, @c)+1
	set @c = right('00'+ltrim(str(@n)), 2)
	end
       return @c
end


GO

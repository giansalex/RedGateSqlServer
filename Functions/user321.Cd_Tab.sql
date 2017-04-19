SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [user321].[Cd_Tab]()
returns char(3) AS
begin 
      declare @c char(3), @n int
      select @c = count(Cd_Tab) from tabla
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_Tab) from tabla
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3 )
	end
       return @c

end

GO

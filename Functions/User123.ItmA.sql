SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE function [User123].[ItmA]()
returns nvarchar(5) AS
begin 
      declare @c nvarchar(5), @n int
      select @c = count(ItmA) from AmarreCta where left(ItmA, 1) = 'Q'
      if @c=0
	set @c='Q0000'
      else
	begin
	select @c=max(right(ItmA,4)) from AmarreCta where left(ItmA, 1) = 'Q'
	set @n =convert(int, @c)+1
	set @c ='Q'+ right('0000'+ltrim(str(@n)), 4)
	end
       return @c
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [user321].[Cd_CDtr](@RucE nvarchar(11))
returns char(4) AS
begin 
      declare @c char(4), @n int
      select @c = count(Cd_CDtr) from ConceptosDetrac where RucE=@RucE
      if @c=0
	set @c='0001'
      else
	begin
	select @c=max(Cd_CDtr)from ConceptosDetrac  where RucE=@RucE
	set @n =convert(int, @c)+1
	set @c = right('0000'+ltrim(str(@n)), 4)
	end
       return @c
end
GO

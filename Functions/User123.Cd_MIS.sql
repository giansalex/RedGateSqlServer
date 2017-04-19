SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_MIS](@RucE nvarchar(11))
returns nvarchar(3) AS
begin 
      declare @c nvarchar(3), @n int
      select @c = count(Cd_MIS) from MtvoIngSal Where RucE=@RucE
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_MIS) from MtvoIngSal Where RucE=@RucE
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3)
	end
       return @c

end
GO

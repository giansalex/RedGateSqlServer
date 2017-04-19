SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [User123].[Cod_CLSS](@RucE nvarchar(11),@Cd_CLSS nvarchar(3))
returns char(3) AS
begin 
      declare @c char(3), @n int
      select @c = count(Cd_CLS) from ClaseSubSub where RucE=@RucE and Cd_CLS=@Cd_CLSS
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_CLS) from ClaseSubSub where RucE=@RucE and Cd_CLS=@Cd_CLSS
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3 )
	end
       return @c

end
GO

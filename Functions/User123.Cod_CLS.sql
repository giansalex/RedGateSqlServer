SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [User123].[Cod_CLS](@RucE nvarchar(11),@Cd_CLS nvarchar(3))
returns char(3) AS
begin 
      declare @c char(3), @n int
      select @c = count(Cd_CLS) from ClaseSub where RucE=@RucE and Cd_CLS=@Cd_CLS
      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_CLS) from ClaseSub where RucE=@RucE and Cd_CLS=@Cd_CLS
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3 )
	end
       return @c

end
GO

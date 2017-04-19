SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_Vnd2](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Vdr) from Vendedor2 where RucE=@RucE
      if @c=0
	set @c='VND0001'
      else
	begin
	select @c=max(Cd_Vdr) from Vendedor2 where RucE=@RucE
	set @c= right(@c,4)
	set @n =convert(int, @c)+1
	set @c ='VND'+ right('0000'+ltrim(str(@n)),4)
	end
       return @c
end
GO

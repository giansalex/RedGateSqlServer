SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_Vin](@RucE nvarchar(11))
returns nvarchar(2) AS
begin 
      declare @c nvarchar(2), @n int
      select @c = count(Cd_Vin) from Vinculo Where RucE=@RucE
      if @c=0
	set @c='01'
      else
	begin
	select @c=max(Cd_Vin)from Vinculo Where RucE=@RucE
	set @n =convert(int, @c)+1
	set @c = right('00'+ltrim(str(@n)), 2)
	end
       return @c
end
GO

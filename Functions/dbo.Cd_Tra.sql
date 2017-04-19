SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_Tra](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Tra) from Transportista where RucE=@RucE
      if @c=0
	set @c='TRA0001'
      else
	begin
	select @c=max(Cd_Tra) from Transportista where RucE=@RucE
	set @c= right(@c,4)
	set @n =convert(int, @c)+1
	set @c ='TRA'+ right('0000'+ltrim(str(@n)),4)
	end
       return @c
end

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Item](@RucE nvarchar(11),@Cd_Clt char(10))
returns int AS
begin 
      declare @n int
      select @n = count(Item) from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt
      if @n=0
	set @n=1
      else
	begin
	select @n= max(Item) from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt
	set @n = @n+1
	end
       return @n
end
GO

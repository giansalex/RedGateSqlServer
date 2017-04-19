SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_CESCo](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(Cd_CESCo) from CfgEnvSC where RucE=@RucE

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Cd_CESCo) from CfgEnvSC where RucE=@RucE

	set @n = @n+1
	end
      return @n
end

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_CEC](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(Cd_CEC) from CfgEnvCorreo where RucE=@RucE

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Cd_CEC) from CfgEnvCorreo where RucE=@RucE

	set @n = @n+1
	end
      return @n
end
GO

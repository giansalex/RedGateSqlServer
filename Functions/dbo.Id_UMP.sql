SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_UMP](@RucE nvarchar(11), @Cd_Prod char(7))
returns int AS
begin 
      declare @n int
      select @n = count(Id_UMP) from Prod_UM where RucE=@RucE and Cd_Prod = @Cd_Prod

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Id_UMP) from Prod_UM where RucE=@RucE and Cd_Prod = @Cd_Prod

	set @n = @n+1
	end
      return @n
end

GO

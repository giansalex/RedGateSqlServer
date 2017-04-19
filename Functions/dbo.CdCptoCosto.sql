SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[CdCptoCosto](@RucE nvarchar(11))
returns char(2)
AS
begin 
	declare @Cd_Cos char(2)

	select @Cd_Cos = count(Cd_Cos) from CptoCosto where RucE = @RucE
	--isnull(max(Cd_Cos),'00') from CptoCosto where RucE = @RucE
	if(@Cd_Cos = 0)
		set @Cd_Cos = '01'
	else 
		begin
		select @Cd_Cos=max(Cd_Cos) from CptoCosto
			set @Cd_Cos = Convert(char, @Cd_Cos) + 1
		end
	return @Cd_Cos
end



GO

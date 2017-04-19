SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[ItemIC](@RucE nvarchar(11),@Cd_IP char(7))
returns int AS
begin
	declare @n int
	select @n = count(ItemIC) from ImpComp where RucE = @RucE and Cd_IP = @Cd_IP
	if @n=0
		set @n=1
	else
	begin
		select @n= max(ItemIC) from ImpComp where RucE = @RucE and Cd_IP = @Cd_IP
		set @n = @n+1
	end
	return @n
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	
	create FUNCTION [dbo].[ID_Obs](@RucE nvarchar(11))
returns int AS
begin
	declare @n int
	select @n = count(ID_Obs) from FabObs where RucE = @RucE 
	if @n=0
		set @n=1
	else
	begin
		select @n= max(ID_Obs) from FabObs where RucE = @RucE 
		set @n = @n+1
	end
	return @n
end
GO

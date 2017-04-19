SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[TareaProgramadaID]
(
	-- Add the parameters for the function here
	@RucE nvarchar(11)
)
RETURNS char(10)
AS
BEGIN
	declare @c char(10), @n int
	select @c = count(TareaProgramadaID) from TareaProgramada where RucE = @RucE
	if @c =0
		set @c = '0000000001'
	else
	begin
		select @c = max(TareaProgramadaID) from TareaProgramada where RucE = @RucE
		set @n = convert(int,@c) + 1
		set @c = right('0000000000'+ltrim(str(@n)), 10)
	end
	

	-- Return the result of the function
	return @c

END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[Item_AmarreCta](@RucE nvarchar(11))
returns nvarchar(5) AS
begin 
	declare @Item int, @n int
	select @Item = MAX(Item) from AmarreCta where RucE = @RucE
	
	if @Item is null
		set @Item=1
	else
	begin
		set @Item = @Item + 1
	end

	return @Item
end

--print dbo.Item_AmarreCta('11111111111', '2011')
GO

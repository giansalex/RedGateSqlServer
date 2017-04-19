SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Cd_TM](
	@RucE nvarchar(11)
)
returns char(2) as
begin
	declare @c char(2)
	declare @n int
	select @c = count(Cd_TM) from TipMant where RucE = @RucE
	if @c = 0
		set @c = '01'
	else
	begin
		select @c = max(Cd_TM) from TipMant where RucE = @RucE
		set @n = convert(int,@c) +1
		set @c = right('00' + ltrim(@n),2)
	end
	return @c
end
GO

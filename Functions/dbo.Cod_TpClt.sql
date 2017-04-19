SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Cod_TpClt](
	@RucE nvarchar(11)
)
returns char(3) as
begin
declare @c char(3)
	declare @n int
	select @c = count(Cd_TClt) from TipClt where RucE = @RucE
	if @c = 0
	set @c = '001'
	else
	begin
	select @c = max(Cd_TClt) from TipClt where RucE =@RucE
	set @n = convert(int,@c) + 1
	set @c = right('000' + ltrim(@n),3)
	end
	return @c
end
GO

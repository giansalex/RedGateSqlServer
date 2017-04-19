SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[Cd_Mnt](
	@RucE	varchar(11),
	@Cd_TM	char(2)
)


returns char(6) as
begin
	declare @c char(6)
	declare @n int
	
	select @c = count(Cd_Mnt) from MantenimientoGN where RucE = @RucE and Cd_TM = @Cd_TM
	if @c = 0
		set @c = '000001'
	else
	begin
		select @c = count(Cd_Mnt) from MantenimientoGN where RucE = @RucE and Cd_TM = @Cd_TM
		set @n = convert(int,@c) +1
		set @c = right('000000' + ltrim(@n),6);
	end
	return @c
end
GO

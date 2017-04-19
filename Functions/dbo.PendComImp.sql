SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[PendComImp](
	@RucE varchar(11),
	@Cd_Com char(10)
)
returns int as
begin
	declare @n int
	set @n = 0
	if not exists (select c.RucE, c.Cd_Com, c.Item, c.Cant - isnull(sum(i.Cant),0) from CompraDet as c left join ImportacionDet as i on c.RucE = i.RucE and c.Cd_Com = i.Cd_Com and c.Item = i.ItemCP 
		where c.RucE = @RucE and c.Cd_Com = @Cd_Com
		group by c.RucE, c.Cd_Com, c.Item, c.Cant
		having c.Cant - isnull(sum(i.Cant),0) >0)
		set @n = 0
	else
	begin
		if exists (select * from ImportacionDet as i where i.RucE = @RucE and i.Cd_Com = @Cd_Com)
			set @n = 1
		else
			set @n = 2
	end
	return @n
end
GO

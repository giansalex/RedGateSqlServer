SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Com_ObtenerEstadoSC_Serv] (@RucE varchar(11), @Cd_SCo char(10))
RETURNS char(2)
AS
BEGIN
	declare @total decimal(13,3), @cantOC decimal(13,3)
	
	select	@total = isnull(sum(case when (Doc = 'A') then Cant else 0 end), 0),
			@cantOC = isnull(sum(case when (Doc = 'B') then Cant else 0 end), 0)
	from(
		select Cd_SRV, isnull(Cant,0) as Cant, 'A' as Doc
		from SolicitudComDet where RucE = @RucE and Cd_SC = @Cd_SCo and Cd_SRV is not null
		union all
		select Cd_SRV, isnull(Cant,0) as Cant, 'B' as Doc
		from OrdCompraDet where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_SRV is not null
	) as t1	
	
	if(@total = 0) return '04'
	if(@cantOC = 0) return '01'
	if(@total = @cantOC) return '03'
	else if(@total > @cantOC) return '02'
	
	return ''
END
GO

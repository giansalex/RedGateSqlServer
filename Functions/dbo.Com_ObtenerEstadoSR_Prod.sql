SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Com_ObtenerEstadoSR_Prod](@RucE varchar(11), @Cd_SR char(10))
RETURNS char(2)
AS
BEGIN
	declare @total decimal(13,3), @cantSC decimal(13,3), @cantINV decimal(13,3)

	select	@total = isnull(sum(case when (Doc = 'A') then Cant else 0 end),0),
			@cantSC = isnull(sum(case when (Doc = 'B') then Cant else 0 end),0),
			@cantINV = isnull(sum(case when (Doc = 'C') then Cant else 0 end),0)
	from (
		select Cd_Prod, isnull(Cant,0) as Cant, 'A' as Doc
		from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
		union all
		select Cd_Prod, isnull(Cant,0) as Cant, 'B' as Doc
		from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
		union all
		select Cd_Prod, isnull(Cant,0) as Cant , 'C' as Doc
		from Inventario where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
	) as saldos

	if(@total = 0) return '08'
	if(@cantSC = 0 and @cantINV = 0)return '04'
	if(@cantINV = 0 and @cantSC > 0)
	begin
		if(@total = @cantSC) return '03'
		else return '01'
	end
	if(@cantSC = 0 and @cantINV > 0)
	begin
		if(@total = @cantINV) return '06'
		else return '05'
	end
	if(@total = (@cantSC + @cantINV)) return '07'
	else return '02'
	
	return '09'
END
GO

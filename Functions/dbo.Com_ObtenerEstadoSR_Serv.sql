SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Com_ObtenerEstadoSR_Serv](@RucE varchar(11), @Cd_SR char(10))
RETURNS char(2)
AS
begin
declare @cantTot decimal(13,3), @cantSC decimal(13,3), @totalSrv int, @atendidos int

select	@totalSrv = isnull(sum(case when (Doc='A') then 1 else 0 end),0), 
		@atendidos = isnull(sum(case when (Doc='A') then IB_AtSrv else 0 end),0),
		@cantTot = isnull(sum(case when (Doc='A') then Cant else 0 end),0),
		@cantSC = isnull(sum(case when (Doc='B') then Cant else 0 end),0)
from (
select Cd_Srv, isnull(Cant,0) as Cant, isnull(IB_AtSrv,0) as IB_AtSrv, 'A' as Doc
from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Srv is not null
union all
select Cd_Srv, isnull(Cant,0) as Cant, isnull(IB_AtSrv,0) as IB_AtSrv, 'B' as Doc
from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Srv is not null
) as t1

if(@totalSrv = 0) return '10'
if(@atendidos = 0 and @cantSC = 0) return '01'
if(@cantTot = @cantSC and @totalSrv = @atendidos) return '09'
if(@cantSC = 0)
begin
	if(@totalSrv = @atendidos) return '03'
	else return '02'
end
else
begin
	if(@atendidos = 0)
	begin
		if(@cantTot = @cantSC) return '07'
		else return '04'
	end
	else if(@totalSrv > @atendidos)
	begin
		if(@cantTot = @cantSC) return '08'
		else return '05'
	end
	else return '06'
end
return '11'
end
GO

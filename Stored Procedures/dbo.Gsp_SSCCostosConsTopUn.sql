SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosConsTopUn]
@RucE nvarchar(11),
@msj varchar(100) output
as

if not exists (select top 1 * from CCSubSub where RucE = @RucE)
	set @msj = 'Sub Sub Centro de Costos no existe'
else	
begin
	if not exists (select top 1 * from CCSubSub where RucE = @RucE and Cd_CC = '01010101')
		select top 1 * from CCSubSub where RucE = @RucE order by Cd_CC,Cd_SC,Cd_SS
	else 
		select top 1 * from CCSubSub where RucE = @RucE  and Cd_CC = '01010101' order by Cd_CC,Cd_SC,Cd_SS
end

print @msj

--MP: 2010-11-29 <Creacion del procedimiento almacenado>
--MP: 2012-05-30 <Modificacion del procedimiento almacenado>
--select top 1 * from CCSubSub where RucE = @RucE order by Cd_CC,Cd_SC,Cd_SS
--select top 1 * from CCSubSub where RucE = '11111111111' and Cd_CC = '01010101' order by Cd_CC,Cd_SC,Cd_SS

GO

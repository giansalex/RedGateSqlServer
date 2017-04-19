SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [dbo].[CostPEPS2](@RucE nvarchar(11),@Cd_Prod char(7),@Cd_Mda char(2),@ID_UMP int)
returns numeric(15,7) AS
begin 
	declare @Cost decimal(15,7)
	if(@Cd_Mda = '01')
		select top 1 @Cost = CosUnt from Inventario  where RucE=@RucE and Cd_Prod=@Cd_Prod and IC_ES = 'E' and Cant <>0 and ID_UMP=@ID_UMP order by FecMov asc, Cd_Inv desc
	else
		select top 1 @Cost = CosUnt_ME from Inventario  where RucE=@RucE and Cd_Prod=@Cd_Prod and IC_ES = 'E' and Cant <>0 and ID_UMP=@ID_UMP order by FecMov asc, Cd_Inv desc
	set @Cost = isnull(@Cost, 0)
	return @Cost
end
GO

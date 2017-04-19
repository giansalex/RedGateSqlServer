SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostPEPS](@RucE nvarchar(11),@Cd_Prod char(7))
returns numeric(13,2) AS
begin 
	declare @Cost decimal(13,3)
	select top 1 @Cost = CosUnt from Inventario  where RucE=@RucE and Cd_Prod=@Cd_Prod and IC_ES = 'E' and Cant <>0
	return @Cost
end
GO

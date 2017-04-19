SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostProm](@RucE nvarchar(11),@Cd_Prod char(7), @FecMov datetime)
returns numeric(13,2) AS
begin 
	declare @Cost decimal(13,3)
	select top 1 @Cost= CProm from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov order by FecMov desc
	set @Cost = isnull(@Cost, 0)
	return @Cost
end
GO

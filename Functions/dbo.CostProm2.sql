SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[CostProm2](@RucE nvarchar(11),@Cd_Prod char(7), @FecMov datetime, @Cd_Mda char(2))
returns numeric(13,2) AS
begin 
	declare @Cost decimal(13,3)
	if(@Cd_Mda = '01')
		select top 1 @Cost= CProm from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov order by FecMov desc
	else
		select top 1 @Cost= CProm_ME from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov order by FecMov desc
	set @Cost = isnull(@Cost, 0)
	return @Cost
end
GO

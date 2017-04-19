SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostProm3](@RucE nvarchar(11),@Cd_Prod char(7), @FecMov datetime, @Cd_Mda char(2))
returns numeric(15,7) AS
begin 
	declare @Cost decimal(15,7)
	if(@Cd_Mda = '01')
		select top 1 @Cost = CProm from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov order by FecMov desc
	else
		select top 1 @Cost = CProm_ME from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov order by FecMov desc
	set @Cost = isnull(@Cost, 0)
	return @Cost
end

-- LEyenda
-- cam 30/06/2012 creacion. aumentar la cantidad de decimales a 7.
GO

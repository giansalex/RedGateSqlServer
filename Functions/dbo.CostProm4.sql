SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostProm4](@RucE nvarchar(11),@Cd_Prod char(7), @FecMov datetime, @Cd_Mda char(2),@ID_UMP int)
returns numeric(15,7) AS
begin 
	declare @Factor numeric(15,7)
	select @Factor = Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	set @Factor = isnull(@Factor, 1)
	
	declare @Cost decimal(15,7)
	if(@Cd_Mda = '01')
		select top 1 @Cost = CProm from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov and ID_UMP=@ID_UMP order by FecMov desc, cd_Inv desc
	else
		select top 1 @Cost = CProm_ME from Inventario where Cd_Prod=@Cd_Prod and RucE=@RucE and FecMov <= @FecMov and ID_UMP=@ID_UMP  order by FecMov desc, cd_Inv desc
	set @Cost = isnull(@Cost, 0)
	return @Cost * @Factor
end

-- LEyenda
-- cam 30/06/2012 creacion. aumentar la cantidad de decimales a 7.
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[CostSal2](@RucE nvarchar(11),@Cd_Prod char(7), @ID_UMP int, @FecMov datetime, @Cd_Mda char(2))
returns numeric(13,2) AS
begin 
	-- deacuerdo a la configuracion escoje
	-- select dbo.CostProm('11111111111','PD00001')
	-- select dbo.CostPEPS('11111111111','PD00001')
 	-- select dbo.CostUEPS('11111111111','PD00001')
	declare @Factor numeric(13,3)
	select @Factor = Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	set @Factor = isnull(@Factor, 1)
	return @Factor * dbo.CostProm2(@RucE,@Cd_Prod, @FecMov, @Cd_Mda)
end
GO

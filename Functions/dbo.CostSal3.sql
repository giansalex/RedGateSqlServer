SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostSal3](@RucE nvarchar(11),@Cd_Prod char(7), @ID_UMP int, @FecMov datetime, @Cd_Mda char(2))
returns numeric(15,7) AS
begin 
	-- deacuerdo a la configuracion escoje
	-- select dbo.CostProm('11111111111','PD00001')
	-- select dbo.CostPEPS('11111111111','PD00001')
 	-- select dbo.CostUEPS('11111111111','PD00001')
	declare @Factor numeric(15,7)
	select @Factor = Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	set @Factor = isnull(@Factor, 1)
	return /*@Factor */ dbo.CostProm4(@RucE,@Cd_Prod, @FecMov, @Cd_Mda, @ID_UMP)
end
-- LEyenda
-- cam 30/06/2012 creacion. aumentar la cantidad de decimales a 7.
GO

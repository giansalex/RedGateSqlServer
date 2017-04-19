SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CostEnt2](@RucE nvarchar(11),@Cd_Prod char(7), @ID_UMP int, @FecMov datetime, @Cd_Mda char(2))
returns numeric(13,2) AS
begin 
	declare @Factor numeric(13,3)
	select @Factor = Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	set @Factor = isnull(@Factor, 1)
	return @Factor * (select top 1 isnull(Case(@Cd_Mda) when '01' then CosUnt else CosUnt_ME end, 0.000) from Inventario where RucE=@RucE and Cd_Prod=@Cd_Prod and IC_ES ='E' and Cant<>0 and FecMov <= @FecMov order by FecMov desc)
end
GO

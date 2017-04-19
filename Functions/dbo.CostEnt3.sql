SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[CostEnt3](@RucE nvarchar(11),@Cd_Prod char(7), @ID_UMP int, @FecMov datetime, @Cd_Mda char(2))
returns numeric(15,7) AS
begin 
	declare @Factor numeric(15,7)
	select @Factor = Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	set @Factor = isnull(@Factor, 1)
	return @Factor * (select top 1 isnull(Case(@Cd_Mda) when '01' then CosUnt else CosUnt_ME end, 0.0000000) from Inventario where RucE=@RucE and Cd_Prod=@Cd_Prod and IC_ES ='E' and Cant<>0 and FecMov <= @FecMov order by FecMov desc)
end
-- LEyenda
-- cam 30/06/2012 creacion. aumentar la cantidad de decimales a 7.
GO

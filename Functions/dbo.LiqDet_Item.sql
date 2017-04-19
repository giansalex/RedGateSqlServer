SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[LiqDet_Item](@RucE nvarchar(11),@Cd_Liq char(10))
returns int AS
begin 
    declare @c int
    if not exists (select Item from LiquidacionDet where RucE=@RucE and Cd_Liq = @Cd_Liq)
		set @c=1
    else
		set @c = (select max(Item) + 1 from LiquidacionDet where RucE=@RucE and Cd_Liq = @Cd_Liq)
    return @c
end
GO

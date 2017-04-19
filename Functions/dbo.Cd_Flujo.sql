SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_Flujo](@RucE nvarchar(11))
returns char(10) AS
begin 
    declare @c nvarchar(10)
    if not exists (select Cd_Flujo from FabFlujo where RucE=@RucE)
		set @c='FL00000001'
    else
		set @c = (select 'FL' + right('0000000000' + convert(varchar, convert(int, right(max(Cd_Flujo),8)) + 1), 8)from FabFlujo where RucE=@RucE)
    return @c
end

GO

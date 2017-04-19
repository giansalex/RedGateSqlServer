SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ID_Prc](@RucE nvarchar(11),@Cd_Flujo char(10))
returns int AS
begin 
    declare @c int
    if not exists (select Cd_Flujo from FabProceso where RucE=@RucE and Cd_Flujo = @Cd_Flujo)
		set @c=1
    else
		set @c = (select max(ID_Prc) + 1 from FabProceso where RucE=@RucE and Cd_Flujo = @Cd_Flujo)
    return @c
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[ID_Rest](@RucE nvarchar(11),@Cd_Flujo char(10), @ID_Prc int)
returns int AS
begin 
    declare @c int
    if not exists (select Cd_Flujo from FabResultado where RucE=@RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc)
		set @c=1
    else
		set @c = (select max(ID_Rest) + 1 from FabResultado where RucE=@RucE and Cd_Flujo = @Cd_Flujo and ID_Prc = @ID_Prc)
    return @c
end
GO

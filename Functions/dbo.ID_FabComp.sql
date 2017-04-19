SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create FUNCTION [dbo].[ID_FabComp](@RucE nvarchar(11),@Cd_Fab char(10))
returns int AS
begin 
    declare @c int
    if not exists (select Cd_Fab from FabComprobante where RucE=@RucE and Cd_Fab = @Cd_Fab)
		set @c=1
    else
		set @c = (select max(ID_Com) + 1 from FabComprobante where RucE=@RucE and Cd_Fab = @Cd_Fab)
    return @c
end
GO

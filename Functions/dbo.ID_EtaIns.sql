SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ID_EtaIns](@RucE nvarchar(11),@Cd_Fab char(10),@Cd_Flujo char(10), @ID_Eta int)
returns int AS
begin 
    declare @c int
    if not exists (select ID_EtaIns from FabEtaIns where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo = @Cd_Flujo and ID_Eta = @ID_Eta)
		set @c=1
    else
		set @c = (select max(ID_EtaIns) + 1 from FabEtaIns where RucE=@RucE and Cd_Fab=@Cd_Fab and Cd_Flujo = @Cd_Flujo and ID_Eta = @ID_Eta)
    return @c
end
GO

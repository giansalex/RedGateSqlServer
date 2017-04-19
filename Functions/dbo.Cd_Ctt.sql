SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_Ctt](@RucE nvarchar(11))
returns int AS
begin 
    declare @c int
    Select @c=isnull(max(Cd_Ctt),0) from Contrato where RucE=@RucE
    Set @c = @c + 1
    return @c
end
GO

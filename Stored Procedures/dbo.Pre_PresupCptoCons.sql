SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupCptoCons]
@RucE nvarchar(11),
as
begin
	select * from PresupCpto where RucE=@RucE
end
print @msj
GO
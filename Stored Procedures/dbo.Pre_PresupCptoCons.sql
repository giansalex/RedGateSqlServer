SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupCptoCons]
@RucE nvarchar(11),@msj varchar(100) output
as
begin
	select * from PresupCpto where RucE=@RucE
end
print @msj
GO

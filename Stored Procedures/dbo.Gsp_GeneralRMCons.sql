SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_GeneralRMCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from GeneralRM where RucE=@RucE)
	set @msj = 'No se encontro registros para esta empresa'
else	
begin
	select * from GeneralRM where RucE=@RucE
end
print @msj
GO

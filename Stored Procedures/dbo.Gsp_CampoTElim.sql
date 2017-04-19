SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoTElim]
@Cd_TC nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from CampoT where Cd_TC=@Cd_TC)
	set @msj = 'Campo Tipo no existe'
else
begin
	delete from CampoT where Cd_TC=@Cd_TC
	if @@rowcount <= 0
	   set @msj = 'Campo Tipo no pudo ser eliminado'
end
print @msj
GO

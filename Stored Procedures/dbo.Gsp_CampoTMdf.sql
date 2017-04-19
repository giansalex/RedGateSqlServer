SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoTMdf]
@Cd_TC nvarchar(2),
@Nombre varchar(50),
@msj varchar(100) output
as
if not exists (select * from CampoT where Cd_TC=@Cd_TC)
	set @msj = 'Campo Tipo no existe'
else
begin
	update CampoT set Nombre=@Nombre where Cd_TC=@Cd_TC
	if @@rowcount <= 0
	   set @msj = 'Campo Tipo no pudo ser modificado'
end
print @msj
GO

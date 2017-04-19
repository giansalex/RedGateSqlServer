SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoTCrea]
@Cd_TC nvarchar(2),
@Nombre varchar(50),
@msj varchar(100) output
as
if exists (select * from CampoT where Cd_TC=@Cd_TC)
	set @msj = 'Ya existe un Campo Tipo con misma informacion'
else
begin
	insert into CampoT(Cd_TC,Nombre)
		    values(@Cd_TC,@Nombre)
	if @@rowcount <= 0
	   set @msj = 'Campo Tipo no pudo ser registrado'
end
print @msj
GO

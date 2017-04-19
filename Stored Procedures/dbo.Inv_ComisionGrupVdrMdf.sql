SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupVdrMdf]
@RucE nvarchar(11),
@Cd_CGV char(3),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from ComisionGrupVdr Where RucE=@RucE and Cd_CGV=@Cd_CGV and Descrip=@Descrip)
	set @msj = 'Comision no existe'
else
begin
	update ComisionGrupVdr set Descrip=@Descrip,Estado=@Estado
	Where RucE=@RucE and Cd_CGV=@Cd_CGV

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Vendedor no pudo ser modificada'
end
print @msj
GO

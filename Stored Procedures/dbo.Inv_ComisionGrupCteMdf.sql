SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupCteMdf]
@RucE nvarchar(11),
@Cd_CGC char(3),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from ComisionGrupCte Where RucE= @RucE and Cd_CGC=@Cd_CGC and Descrip=@Descrip)
	set @msj = 'Comision no existe'
else
begin
	update ComisionGrupCte set Descrip=@Descrip,Estado=@Estado
	 Where RucE= @RucE and Cd_CGC=@Cd_CGC and Descrip=@Descrip

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Cliente no pudo ser modificada'
end
print @msj
GO

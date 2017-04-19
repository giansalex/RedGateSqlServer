SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupVdrCrea]
@RucE nvarchar(11),
@Descrip varchar(100),
@msj varchar(100) output
as
if exists (select * from ComisionGrupVdr Where RucE=@RucE and Descrip=@Descrip)
	set @msj = 'Ya existe Comision con descripcion'+' '+@Descrip
else
begin
	insert into ComisionGrupVdr(RucE,Cd_CGV,Descrip,Estado)
		     values(@RucE,user123.Cd_CGV(@RucE),@Descrip,1)

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo del Vendedor no pudo ser ingresado'

end
print @msj
GO

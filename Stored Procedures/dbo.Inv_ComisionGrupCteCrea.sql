SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupCteCrea]
@RucE nvarchar(11),
@Descrip varchar(100),
@msj varchar(100) output
as
if exists (select * from ComisionGrupCte Where RucE= @RucE and Descrip=@Descrip)
	set @msj = 'Ya existe Comision con descripcion'+' '+@Descrip
else
begin
	insert into ComisionGrupCte(RucE,Cd_CGC,Descrip,Estado)
		     values(@RucE,user123.Cd_CGC(@RucE),@Descrip,1)

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo del Cliente no pudo ser ingresado'

end
print @msj
GO

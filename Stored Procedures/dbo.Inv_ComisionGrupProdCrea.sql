SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupProdCrea]
@RucE nvarchar(11),
@Descrip varchar(100),
@msj varchar(100) output
as
if exists (select * from ComisionGrupProd Where RucE=@RucE and Descrip=@Descrip)
	set @msj = 'Ya existe Comision con descripcion'+' '+@Descrip
else
begin
	insert into ComisionGrupProd(RucE,Cd_CGP,Descrip,Estado)
		     values(@RucE,user123.Cd_CGP(@RucE),@Descrip,1)

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo del Producto no pudo ser ingresado'

end
print @msj
GO

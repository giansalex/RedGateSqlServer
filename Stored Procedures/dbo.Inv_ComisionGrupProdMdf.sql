SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupProdMdf]
@RucE nvarchar(11),
@Cd_CGP char(3),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from ComisionGrupProd Where RucE=@RucE and Cd_CGP=@Cd_CGP and Descrip=@Descrip)
	set @msj = 'Comision no existe'
else
begin
	update ComisionGrupProd set Descrip=@Descrip,Estado=@Estado
	Where RucE=@RucE and Cd_CGP=@Cd_CGP

	if @@rowcount <= 0
	   set @msj = 'Comision de Grupo de Producto no pudo ser modificada'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[EliminarFormula]
@RucE nvarchar(11),
@ID_Fmla int,
@msj varchar(100) output
as
if not exists (select * from Formula where RucE=@RucE and ID_Fmla=@ID_Fmla)
	set @msj = 'Insumo no existe'
else if exists (select * from OrdFabricacion where RucE=@RucE and ID_Fmla=@ID_Fmla)
	set @msj = 'Existen Formular utilizadas en ordenes de fabricacion'
else
begin
	delete from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla
	delete from Formula where RucE=@RucE and ID_Fmla=@ID_Fmla
	if @@rowcount <= 0
	   set @msj = 'Formula no pudo ser eliminada'
end
print @msj
GO

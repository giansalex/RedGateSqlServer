SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [user321].[Prd_FormulaDetElimAll]
@RucE nvarchar(11),
@ID_Fmla int,
@msj varchar(100) output
as
if not exists (select * from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla)
	set @msj = 'Insumo no existe'
else
begin
	delete from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla
	if @@rowcount <= 0
	   set @msj = 'Los Insumos no pueden ser eliminados'
end
print @msj

--select * from FormulaDet where ruce='11111111111' and ID_Fmla='89'

-- delete from FormulaDet where RucE='11111111111' and ID_Fmla='89'
GO

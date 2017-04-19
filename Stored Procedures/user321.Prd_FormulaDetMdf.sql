SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormulaDetMdf]
@RucE nvarchar(11),
@ID_Fmla int,
@Item int,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(16,6),
@Mer numeric(16,6),
@MerPorc numeric(16,6),
@Obs varchar(500),
@Cd_Cos char(2),
@msj varchar(100) output
as
if not exists (select * from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla and Item=@Item)
	set @msj = 'Detalle de Formula no existe'
else
begin
	update FormulaDet set Cd_Prod=@Cd_Prod, ID_UMP=@ID_UMP, Cant=@Cant, Mer=@Mer, MerPorc=@MerPorc, Obs=@Obs, Cd_Cos=@Cd_Cos
	where RucE=@RucE and ID_Fmla=@ID_Fmla and Item=@Item 
	if @@rowcount <= 0
	   set @msj = 'Detalle de Formula no pudo ser modificada'
end
print @msj




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [user321].[Prd_FormulaDetCrea_2]
@RucE nvarchar(11),
@ID_Fmla int,
@Item int output,
@Cd_Prod char(7),
@ID_UMP int,
@Cant numeric(16,6),
@Mer numeric(16,6),
@MerPorc numeric(16,6),
@Obs varchar(500),
@Cd_Cos char(2),
@msj varchar(100) output

as
Set @Item = dbo.FormulaDetItem(@RucE,@ID_Fmla)

if exists (select * from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla and Item=@Item)
	Set @msj = 'Esta detalle ya ha sido registrada' 

else
begin 
	insert into FormulaDet(RucE,ID_Fmla,Item,Cd_Prod,ID_UMP,Cant,Mer,MerPorc,Obs,Cd_Cos)
			values(@RucE,@ID_Fmla,@Item,@Cd_Prod,@ID_UMP,@Cant,@Mer,@MerPorc,@Obs,@Cd_Cos)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar Detalle de Formula'
end
-- Leyenda --
-- FL : 2011-02-05 : <Creacion del procedimiento almacenado>


GO

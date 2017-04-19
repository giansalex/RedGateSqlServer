SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormDetConsUn]
@RucE nvarchar(11),
@ID_Fmla int,
@Item int,
@msj varchar(100) output
as
if not exists (select * from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla and Item=@Item)
	set @msj = 'Formula no existe'
else	select * from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla and Item=@Item
print @msj




GO

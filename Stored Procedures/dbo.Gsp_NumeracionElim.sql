SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NumeracionElim]
@RucE nvarchar(11),
@Cd_Num nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Numeracion where RucE=@RucE and Cd_Num=@Cd_Num)
	set @msj = 'Numeracion no existe'
else
begin
	delete from Numeracion where RucE=@RucE and Cd_Num=@Cd_Num
	if @@rowcount <= 0
	   set @msj = 'Numeracion no pudo ser eliminado'
end
print @msj
GO

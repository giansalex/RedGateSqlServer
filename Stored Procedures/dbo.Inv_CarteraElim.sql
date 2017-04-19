SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraElim]
@RucE nvarchar(11),
@Cd_Ct char(3),
@msj varchar(100) output
as
if not exists (select * from CarteraProd where Cd_Ct=@Cd_Ct)
	set @msj = 'Cartera de Productos no existe'
else
begin
	delete from CarteraProd where RucE=@RucE and Cd_Ct=@Cd_Ct

	if @@rowcount <= 0
	set @msj = 'Cartera de Productos no pudo ser eliminado'	
end

GO

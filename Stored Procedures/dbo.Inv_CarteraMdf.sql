SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraMdf]
@RucE nvarchar(11),
@Cd_Ct nvarchar(3),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from CarteraProd where Cd_Ct=@Cd_Ct)
	set @msj = 'Cartera de Productos no existe'
else
begin
	update CarteraProd set Descrip=@Descrip,Estado=@Estado
	where RucE=@RucE and Cd_Ct=@Cd_Ct

	if @@rowcount <= 0
	set @msj = 'Cartera de Productos no pudo ser modificada'	
end

GO

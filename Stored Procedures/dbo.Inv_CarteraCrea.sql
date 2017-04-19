SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraCrea]
@RucE nvarchar(11),
@Cd_Ct char(3) output,
@Descrip varchar(100),
@msj varchar(100) output
as
if exists (select * from CarteraProd where Descrip=@Descrip)
	set @msj = 'Ya existe una Cartera de Productos con la descripcion ['+@Descrip+']'
else
begin
	set @Cd_Ct = user123.Cd_Ct(@RucE)
	insert into CarteraProd(RucE,Cd_Ct,Descrip,Estado)
	values(@RucE,@Cd_Ct,@Descrip,1)	
	
	if @@rowcount <= 0
	set @msj = 'Cartera de Productos no pudo ser registrado'	
end
GO

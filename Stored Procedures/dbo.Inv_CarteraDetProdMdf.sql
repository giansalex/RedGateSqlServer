SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetProdMdf]
@RucE nvarchar(11),
@Cd_Ct char(3),
@Cd_Prod char(7),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from CarteraProdDet_P where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Prod=@Cd_Prod)
	set @msj = 'No existe'
else
begin
	update CarteraProdDet_P set Estado=@Estado
		Where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Prod=@Cd_Prod
	
	if @@rowcount <= 0
	set @msj = 'Detalle de Cartera de Productos no pudo ser modificado'	
end
print @msj
-------------
--J : 25-03-2010 <creado>
GO

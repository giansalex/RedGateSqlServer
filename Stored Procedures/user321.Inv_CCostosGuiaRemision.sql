SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_CCostosGuiaRemision]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Eje nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no ha sido creada'
else
begin
	select Cd_CC,Cd_SC,Cd_SS from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta
	
	if @@rowcount <= 0
		set @msj = 'Centros de Costo no pueden ser consultados'
end
print @msj



GO

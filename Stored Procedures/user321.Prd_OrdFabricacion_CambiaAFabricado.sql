SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Prd_OrdFabricacion_CambiaAFabricado]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)
begin
	set @msj = 'No existe la orden de fabricacion'
	return
end
if ((select Id_EstOF from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)='01')
begin
	set @msj = 'No se puede cambiar de estado a Fabricado. El documento aun esta Pendiente de Fabricación'
	return
end
if ((select Id_EstOF from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)='02')
begin
	update OrdFabricacion
	set Id_EstOF = '03'
	where RucE = @RucE and Cd_OF = @Cd_OF and Id_EstOF = '02'
	if(@@rowcount<=0)
		set @msj = 'No se pudo actualizar el estado del documento'
end
GO

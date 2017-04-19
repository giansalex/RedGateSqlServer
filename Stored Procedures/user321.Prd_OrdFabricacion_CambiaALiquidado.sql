SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Prd_OrdFabricacion_CambiaALiquidado]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)
begin
	set @msj = 'No existe la orden de fabricacion'
	return
end
declare @IdEstado char(2)
set @IdEstado = (select Id_EstOF from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)
if (@IdEstado='02' or @IdEstado='01')
begin
	set @msj = 'No se puede liquidar el documento. El estado del documento tiene que ser Fabricado'
	return	
end
if(@IdEstado='04')
begin
	set @msj = 'El documento ya fue Liquidado'
end
GO

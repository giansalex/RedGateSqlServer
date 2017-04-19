SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionElimina1]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR)
	set @msj = 'Guia de Remision No Existe'
else
begin

Begin Transaction

	declare @IC_ES char(1)
	set @IC_ES = (select IC_ES from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR)

	IF exists(select * from GuiaRemisionDet where RucE=@RucE and Cd_GR=@Cd_GR)
	BEGIN
		delete from GuiaRemisionDet where RucE=@RucE and Cd_GR=@Cd_GR
		If @@RowCount <= 0
		Begin	Set @msj = 'No se pudo eliminar informacion, <GuiaRemisionDet>'
			Rollback Transaction
			return		
		End
	END

	IF exists(select * from GRPtoLlegada where RucE=@RucE and Cd_GR=@Cd_GR)
	BEGIN
		delete from GRPtoLlegada where RucE=@RucE and Cd_GR=@Cd_GR
		If @@RowCount <= 0
		Begin	Set @msj = 'No se pudo eliminar informacion, <GRPtoLlegada>'
			Rollback Transaction
			return		
		End
	END

	IF(@IC_ES='E')
		BEGIN
			IF exists(select * from GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR)
			Begin
				delete from GuiaXCompra where RucE=@RucE and Cd_GR=@Cd_GR
				If @@RowCount <= 0
				Begin	Set @msj = 'No se pudo eliminar informacion, <GuiaXCompra>'
					Rollback Transaction
					return		
				End
			End
		END
	ELSE
		BEGIN
			IF exists(select * from GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR)
			Begin
				delete from GuiaXVenta where RucE=@RucE and Cd_GR=@Cd_GR
				If @@RowCount <= 0
				Begin	Set @msj = 'No se pudo eliminar informacion, <GuiaXVenta>'
					Rollback Transaction
					return		
				End
			End
		END

	IF exists(select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR)
	BEGIN	
		delete from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
		If @@RowCount <= 0
		Begin	Set @msj = 'No se pudo eliminar informacion, <GuiaRemision>'
			Rollback Transaction
			return		
		End
	END

Commit Transaction
end
print @msj

-- Leyenda --
-- FL : 2010-11-10 : <Creacion del procedimiento almacenado>
-- FL : 2010-12-21 : <Modificacion del procedimiento almacenado>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Prd_OrdFabricacionElim]

@RucE nvarchar(11),
@Cd_OF char(10),
@NroOF varchar(50),
@msj varchar(100) output

AS

If not exists (Select * from OrdFabricacion Where RucE=@RucE and Cd_OF=@Cd_OF)
	Set @msj = 'No existe la orden de fabricacion '+@NroOF
Else If exists (Select * from Inventario Where RucE=@RucE and Cd_OF=@Cd_OF)
Begin
	Set @msj = 'No se puede eliminar orden de fabricacion '+@NroOF+', se encuentra incluido en inventario'
End
Else
Begin
Begin Transaction
	if exists (select * from AutOF where RucE=@RucE and Cd_OF=@Cd_OF)
	begin
		delete from AutOF where RucE=@RucE and Cd_OF=@Cd_OF
		if(@@rowcount<=0)
		begin
			set @msj = 'Error al eliminar las autorizaciones de la OF'
		end
	end
	If exists (select * from CptoCostoOFDoc Where RucE=@RucE and Cd_OF=@Cd_OF)
	Begin
		Delete From CptoCostoOFDoc Where RucE=@RucE and Cd_OF=@Cd_OF
		If @@RowCount <= 0
		Begin	Set @msj = 'No se puedo eliminar informacion, <CptoCostoOFDoc>'
			Rollback Transaction
			return		
		End
	End
	If exists (select * from CptoCostoOF Where RucE=@RucE and Cd_OF=@Cd_OF)
	Begin
		Delete From CptoCostoOF Where RucE=@RucE and Cd_OF=@Cd_OF
		If @@RowCount <= 0
		Begin	Set @msj = 'No se puedo eliminar informacion, <CptoCostoOF>'
			Rollback Transaction
			return
		End
	End
	If exists (select * from FrmlaOF Where RucE=@RucE and Cd_OF=@Cd_OF)
	Begin
		Delete From FrmlaOF Where RucE=@RucE and Cd_OF=@Cd_OF
		If @@RowCount <= 0
		Begin	Set @msj = 'No se puedo eliminar informacion, <FrmlaOF>'
			Rollback Transaction
			return
		End
	End
	If exists (select * from EnvEmbOF Where RucE=@RucE and Cd_OF=@Cd_OF)
	Begin
		Delete From EnvEmbOF Where RucE=@RucE and Cd_OF=@Cd_OF
		If @@RowCount <= 0
		Begin	Set @msj = 'No se puedo eliminar informacion, <EnvEmbOF>'
			Rollback Transaction
			return
		End
	End
	If exists (select * from OrdFabricacion Where RucE=@RucE and Cd_OF=@Cd_OF)
	Begin
		Delete From OrdFabricacion Where RucE=@RucE and Cd_OF=@Cd_OF
		If @@RowCount <= 0
		Begin	Set @msj = 'No se puedo eliminar informacion, <OrdFabricacion>'
			Rollback Transaction
			return
		End
	End

Commit Transaction	
End

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFCElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),

@msj varchar(100) output

AS

Begin Transaction

	Declare @Tipo varchar(2)
	Set @Tipo = ''
	If(isnull(@Cd_SS,'') <> '') Set @Tipo = 'ss'
	Else If(isnull(@Cd_SC,'') <> '') Set @Tipo = 'sc'
	Else If(isnull(@Cd_CC,'') <> '') Set @Tipo = 'cc'
	
	
	If (@Tipo = 'ss')
	Begin	-- Eliminar por sub sub centro de costos
		If exists (Select * From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
		Begin
			Delete From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS
			
			If @@Rowcount <= 0
			Begin
				Set @msj = 'Error al eliminar presupuesto flujo caja (cc,sc,ss)'
				Rollback Transaction
				return
			End
		End
	End
	Else If (@Tipo = 'sc')
	Begin	-- Eliminar por sub centro de costos
		If exists (Select * From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
		Begin
			Delete From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
			
			If @@Rowcount <= 0
			Begin
				Set @msj = 'Error al eliminar presupuesto flujo caja (cc,sc)'
				Rollback Transaction
				return
			End
		End
	End
	Else If (@Tipo = 'cc')
	Begin	-- Eliminar por centro de costos
		If exists (Select * From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC)
		Begin
			Delete From PresupFC where RucE=@RucE and Ejer=@Ejer and Cd_CC=@Cd_CC
			
			If @@Rowcount <= 0
			Begin
				Set @msj = 'Error al eliminar presupuesto flujo caja (cc)'
				Rollback Transaction
				return
			End
		End
	End
commit transaction

-- Leyenda --
-- Di: 25/01/2011 <Creacion del procedimiento almacenado>

GO

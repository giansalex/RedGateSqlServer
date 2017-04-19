SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_ObtenerDatosDoc2]

@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Vou nvarchar(10),
@msj varchar(100) output

AS

if(@Cd_Vta<>'')
Begin

	If not exists (Select * From Venta Where RucE=@RucE and Cd_Vta=@Cd_Vta)
		Set @msj = 'No existe documento'
	Else
	Begin
		Select * From Venta Where RucE=@RucE and Cd_Vta=@Cd_Vta
	End
	
End
Else
Begin

	If not exists (Select * From Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
		Set @msj = 'No existe documento'
	Else
	Begin
		Select * From Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou
	End
	
End

-- Leyenda --
-- DI : 17/08/2012 <Creacion del SP y se agrego voucher>
GO

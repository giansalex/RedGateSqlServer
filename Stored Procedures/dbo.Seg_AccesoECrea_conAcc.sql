SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Seg_AccesoECrea_conAcc]

@Cd_Prf nvarchar(6),
@RucE nvarchar(11),
@Cd_GA int,
@msj varchar(100) output

AS

if not exists (Select * From AccesoE Where Cd_Prf=@Cd_Prf and RucE=@RucE and Cd_GA=@Cd_GA)
Begin
	Insert Into AccesoE(Cd_Prf,RucE,cd_GA) Values(@Cd_Prf,@RucE,@Cd_GA)
	
	if @@rowcount <= 0
		Set @msj = 'No se puedo insertar acceso'
End

-- Leyenda --
-- DI : 13/07/2011 <Creacion del procedimiento almacenado>

GO

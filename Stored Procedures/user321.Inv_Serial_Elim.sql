SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [user321].[Inv_Serial_Elim]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@msj varchar(100) output
as

BEGIN TRANSACTION
	if exists (select * from Serial where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial)
		delete Serial where RucE = @RucE and Cd_Prod = @Cd_Prod and Serial = @Serial
	else return
	if(@@rowcount<=0)
	BEGIN
		set @msj = 'No se puedo eliminar la serie por el producto'
		ROLLBACK TRANSACTION
		RETURN
	END
COMMIT TRANSACTION
GO

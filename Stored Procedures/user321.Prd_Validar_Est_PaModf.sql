SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Prd_Validar_Est_PaModf]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
declare @estado char(2)
set @estado = (select ID_EstOF from ordFabricacion ofb where RucE = @RucE and Cd_OF = @Cd_OF)
if(@estado != '01')
	set @msj = 'La OF debe tener el estado de pendiente para poder modificarla.'

GO

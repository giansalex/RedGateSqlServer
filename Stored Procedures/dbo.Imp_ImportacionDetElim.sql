SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Imp_ImportacionDetElim]
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as 
begin transaction

delete ImportacionDet where RucE = @RucE and Cd_IP=@Cd_IP
if @@rowcount <= 0
begin	set @msj = 'Importacion no pudo ser eliminada'
	rollback transaction
end
	commit transaction

-- Leyenda --
-- PP : 2010-08-20 19:38:17.483	: <Creacion del procedimiento almacenado>
GO

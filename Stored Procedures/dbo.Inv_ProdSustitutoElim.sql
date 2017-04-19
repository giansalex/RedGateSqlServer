SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdSustitutoElim]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@Cd_ProdS char(7),
@msj varchar(100) output
as
if not exists (select * from ProdSustituto where RucE = @RucE and Cd_ProdB = @Cd_ProdB and Cd_ProdS = @Cd_ProdS)
	set @msj = 'Sustituto no existe'
else
begin
	delete from ProdSustituto  where RucE = @RucE and Cd_ProdB = @Cd_ProdB and Cd_ProdS = @Cd_ProdS
	
	if @@rowcount <= 0
	set @msj = 'sustituto no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- PP : 2010-03-11 13:20:43 : <Creacion del procedimiento almacenado>
GO

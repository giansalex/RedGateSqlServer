SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------	

CREATE PROCEDURE [user321].[Inv_CptoCosto_Elim]
@RucE nvarchar(11),
@Cd_Cos char(2),
@msj varchar(100) output
as

if not exists(select * from CptoCosto where Cd_Cos = @Cd_Cos and RucE = @RucE)
begin
	set @msj = 'No existe el concepto de costo'
	return
end

delete from CptoCosto where Cd_Cos = @Cd_Cos and RucE = @RucE
if(@@rowcount<=0)
	set @msj = 'No se pudo eliminar el concepto'

GO

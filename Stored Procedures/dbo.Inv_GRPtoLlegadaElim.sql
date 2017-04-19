SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GRPtoLlegadaElim]
@RucE nvarchar(11),
@Cd_GR char(10),
@Item int,
@msj varchar(100) output
as
if not exists (select * from GRPtoLlegada where RucE= @RucE  and Cd_GR= @Cd_GR and Item = @Item)
	set @msj = 'Punto de llegada no existe'
else
begin
	delete from GRPtoLlegada where RucE= @RucE  and Cd_GR= @Cd_GR and Item = @Item
	if @@rowcount <= 0
	set @msj = 'Punto de llegada no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- PP : 2010-05-05 13:34:11.150	: <Creacion del procedimiento almacenado>
GO

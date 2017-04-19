SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamElim]
@FecTC varchar(10),
@msj varchar(100) output
as
/*if not exists (select * from TipCam where FecTC=@FecTC)
   set @msj = 'Fecha Tipo de Cambio no existe'
else
begin
   delete TipCam Where FecTC = @FecTC
   if @@rowcount <= 0
	set @msj = 'Tipo de Cambio no pudo ser eliminado'
end
print @msj*/
set @msj = 'Debe Actualizar el sistema, comunicarse con el area de sistemas'
GO

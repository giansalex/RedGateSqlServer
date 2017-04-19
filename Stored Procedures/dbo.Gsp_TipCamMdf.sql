SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamMdf]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@TCCom numeric(13,3),
@TCVta numeric(13,3),
@TCPro numeric(13,3),
@msj varchar(100) output
as
/*if not exists (select * from TipCam where FecTC=@FecTC)
   set @msj = 'Fecha Tipo de Cambio no existe'
else
begin
	update TipCam set Cd_Mda=@Cd_Mda, TCCom=@TCCom, TCVta=@TCVta, TCPro=@TCPro
	where FecTC=@FecTC
	
	if @@rowcount <= 0
      	set @msj = 'Tipo de Cambio no pudo ser modificado'
end
print @msj*/
set @msj = 'Debe Actualizar el sistema, comunicarse con el area de sistemas'
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamCrea]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@TCCom numeric(13,3),
@TCVta numeric(13,3),
@TCPro numeric(13,3),
@msj varchar(100) output
as
/*if exists (select * from TipCam where FecTC=@FecTC and Cd_Mda=@Cd_Mda)
   set @msj = 'Fecha Tipo de Cambio ya existe'
else
begin
    insert into TipCam(FecTC,Cd_Mda,TCCom,TCVta,TCPro)
	        values (@FecTC,@Cd_mda,@TCCom,@TCVta,@TCPro)
    if @@rowcount<=0
       set @msj = 'Tipo de Cambio no pudo ser ingresado'
end
print @msj*/
set @msj = 'Debe Actualizar el sistema, comunicarse con el area de sistemas'
GO

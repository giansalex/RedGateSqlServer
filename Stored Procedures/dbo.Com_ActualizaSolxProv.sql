SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_ActualizaSolxProv]
@RucE nvarchar(11),
@Cd_SCo char(100),
@Cd_Prv char(7),
@Indicador char(8),
@msj varchar(100) output
as

if exists (select * from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_Prv = @Cd_Prv)
begin
	update SCxProv set Indicador = @Indicador where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_Prv = @Cd_Prv
end
else
begin
	set @msj = 'No existe el envio de la Solicitud de Compra ' + @Cd_SCo
end

-- LEYENDA
-- CAM 09/05/2012 creacion
-- select * from SolicitudCom where RucE = '11111111111'
-- select RucE, Cd_SCo,Cd_Prv,Indicador from SCxProv where RucE = '11111111111' and Cd_SCo = 'SC00000227' --and Cd_Prv = 'PRV0222'

GO

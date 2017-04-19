SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Cfg_CgfAutorizacion_ConsxDocumento]
@RucE nvarchar(11),
@Cd_TDES char(2),
@msj varchar(100) output
as
	if not exists (select * from cfgAutorizacion where RucE = @RucE and Cd_DMA = @Cd_TDES and IB_Hab = 1)
		set @msj = 'No hay autorizaciones creadas para este documento.'

-- Leyenda --
-- CAM : 2012-12-12    : <Creacion del procedimiento almacenado>


--select * from cfgAutorizacion where RucE = '11111111111' and Cd_DMA = 'SR' and IB_Hab = 1
GO

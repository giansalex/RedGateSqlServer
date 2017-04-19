SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_CfgAutorizacion_Cons_Tipo]
@RucE nvarchar(11),
@TipoCD int,
@msj varchar(100) output
as 
	if not exists (select * from Empresa where Ruc = @RucE)
		set @msj = 'No existe la empresa'
	else
	begin
		declare @Cd_DMA char(2)
		if(@TipoCD = 0)   set @Cd_DMA = 'OC'
		else if(@TipoCD = 1)  set @Cd_DMA = 'OP'
		else if(@TipoCD = 2)  set @Cd_DMA = 'SC'
		else if(@TipoCD = 3)  set @Cd_DMA = 'SR'
		else if(@TipoCD = 4)  set @Cd_DMA = 'OF'
		else if(@TipoCD = 5)  set @Cd_DMA = 'CT'
		
		select Id_Aut, Tipo,  Cd_DMA, DescripTip from cfgAutorizacion where RucE = @RucE and Cd_DMA = @Cd_DMA and IB_Hab = 1
	end	

-- Leyenda --
-- MM : 2010-01-18    : <Creacion del procedimiento almacenado>
--  exec Cfg_CfgAutorizacion_Cons_Tipo '11111111111', 0

GO

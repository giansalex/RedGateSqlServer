SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_DocMovAuts_UltTipoxDoc]
@RucE nvarchar(11),
@Cd_DMA char(2),
@msj varchar(100) output
as
	if((select Count(*) from DocMovAUts) = 0)
		set @msj = 'No existen documentos'
	else
	begin
		select isnull(Max(Tipo),0)+1 as Tipo 
		from CfgAutorizacion where RucE=@RucE and Cd_DMA=@Cd_DMA
	end
-- Leyenda --
-- JJ : 2010-01-14    : <Creacion del procedimiento almacenado>
--exec Cfg_DocMovAuts_UltTipoxDoc '11111111111','OC',null
GO

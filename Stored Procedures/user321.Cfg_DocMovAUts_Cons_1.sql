SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_DocMovAUts_Cons_1]
--@RucE nvarchar(11),
@msj varchar(100) output
as	
	if((select count(*) from DocMovAUts) = 0)
		set @msj = 'No existen documentos'
	else
	begin
		select * from DocMovAUts
/*		select a.Cd_DMA, a.Descrip, a.Estado 
		from(
			select * from CfgAutorizacion where RucE = @RucE
		) as b
		right join DocMovAUts a on b.Cd_DMA = a.Cd_DMA
		--where b.Id_Aut is null
*/
	end

-- Leyenda --
-- MM : 2010-01-04    : <Creacion del procedimiento almacenado>
-- JJ : 2010-01-14    : <Modificacion del procedimiento almacenado, Comentada linea Where>
-- exec Cfg_DocMovAUts_Cons '11111111111',null

GO

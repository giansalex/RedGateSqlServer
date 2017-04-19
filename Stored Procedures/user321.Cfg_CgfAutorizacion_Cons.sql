SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_CgfAutorizacion_Cons]
@RucE nvarchar(11),
@msj varchar(100) output
as
	if not exists (select * from empresa where Ruc = @RucE)
		set @msj = 'No existe empresa'
	else
	begin
		select t1.Id_Aut, t2.Cd_DMA, t2.Descrip,t1.Tipo,t1.DescripTip, t1.NroNiveles, t1.IB_Hab
		from(
			select count(a.Id_Niv) as 'NroNiveles',b.Id_Aut, b.Cd_DMA, b.IB_Hab,b.Tipo,b.DescripTip
			from cfgnivelaut a
			right join  cfgAutorizacion b on a.Id_Aut = b.Id_Aut
			where RucE = @RucE
			group by b.Id_Aut, b.Cd_DMA, b.IB_Hab,b.Tipo,b.DescripTip
		) as t1
		join DocMovAUts t2 on t1.Cd_DMA = t2.Cd_DMA
		set @msj = ''
	end

-- Leyenda --
-- MM : 2010-01-04    : <Creacion del procedimiento almacenado>
-- JJ : 2010-01-14    : <Modificacion del sp, se agrego Tipo y DescripTip de cfgAutorizacion>
GO

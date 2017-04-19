SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_CfgAutorizacion_Mdf]
@Id_Aut int,
@IB_Hab bit,
@DescripTip varchar(100),
@msj varchar(100) output
as
	if not exists (select * from CfgAutorizacion where Id_Aut = @Id_Aut)
		set @msj = 'No existe la autorizacion'
	else
	begin
		update CfgAutorizacion
		set IB_Hab = @IB_Hab, DescripTip=@DescripTip
		where Id_Aut = @Id_Aut
	end

-- Leyenda --
-- MM : 2010-01-04    : <Creacion del procedimiento almacenado>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoExistenciaConsUn]
@Cd_TE char(2),
@msj varchar(100) output
as
if not exists (select * from TipoExistencia where Cd_TE=@Cd_TE)
	set @msj = 'Tipo de Existencia no encontrada'
else	select * from TipoExistencia where Cd_TE=@Cd_TE
GO

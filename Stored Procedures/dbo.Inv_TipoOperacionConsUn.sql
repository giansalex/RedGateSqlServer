SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionConsUn]--<Procemiento que consulta x tipo de operacion p.ej. Input,Output>
@Cd_TO char(2),
@msj varchar(100) output
as
if not exists (select * from TipoOperacion where Cd_TO=@Cd_TO)
	set @msj = 'Tipo de Operación no existe'
else	select * from TipoOperacion where Cd_TO=@Cd_TO

GO

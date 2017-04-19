SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaElim_X_Cta]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@msj varchar(100) output
as
set @msj = 'Para eliminar actualice el sistema'
/*begin
	delete from AmarreCta where RucE=@RucE and NroCta=@NroCta

	if @@rowcount <= 0
		set @msj = 'No se elimino ningun amarre'
end*/

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_TipCamRMElim]
@NroReg int,
@msj varchar(100) output
as
begin
	delete from TipCamRM where NroReg=@NroReg
	if @@rowcount <= 0
	   set @msj = 'Error al eliminar TipCamRM'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarRMElim]
@NroReg int,
@RucE nvarchar(11),
@msj varchar(100) output
as
begin
	delete from AuxiliarRM where NroReg=@NroReg and RucE=@RucE
	if @@rowcount <= 0
	   set @msj = 'Error al eliminar AuxiliarRM'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipAuxElim]
@Cd_TA nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipAux where Cd_TA=@Cd_TA)
	set @msj = 'Tipo Auxiliar no existe'
else
begin
	delete from TipAux Where Cd_TA=@Cd_TA
	if @@rowcount <= 0
		set @msj = 'Tipo Auxiliar no pudo ser eliminado'
end
print @msj
GO

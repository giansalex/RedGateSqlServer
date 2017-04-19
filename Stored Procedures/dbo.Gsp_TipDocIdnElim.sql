SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocIdnElim]
@Cd_TDI nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipDocIdn where Cd_TDI=@Cd_TDI)
	set @msj = 'Tipo Documento Identidad no existe'
else
begin
	delete TipDocIdn Where Cd_TDI=@Cd_TDI
	if @@rowcount <= 0
		set @msj = 'Tipo Documento Identidad no pudo ser eliminado'
end
print @msj
GO

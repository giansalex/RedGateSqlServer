SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocIdnModf]
@Cd_TDI nvarchar(2),
@Descrip varchar(50),
@NCorto varchar(6),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipDocIdn where Cd_TDI=@Cd_TDI)
	set @msj = 'Tipo Documento Identidad no existe'
else
begin
	update TipDocIdn set Descrip=@Descrip, NCorto=@NCorto, Estado=@Estado
		where Cd_TDI=@Cd_TDI
	if @@rowcount <= 0
		set @msj = 'Tipo Documento Identidad no pudo ser modificado'
end
print @msj
GO

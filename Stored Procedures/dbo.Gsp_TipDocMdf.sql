SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocMdf]
@Cd_TD nvarchar(2),
@Descrip varchar(50),
@NCorto varchar(6),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipDoc where Cd_TD=@Cd_TD)
	set @msj = 'Tipo Documento no existe'
else
begin
	update TipDoc set Cd_TD=@Cd_TD, Descrip=@Descrip, NCorto=@NCorto, Estado=@Estado
	where Cd_TD=@Cd_TD

	if @@rowcount <= 0
	   set @msj = 'Tipo Documento no pudo ser modificado'
end
print @msj
GO

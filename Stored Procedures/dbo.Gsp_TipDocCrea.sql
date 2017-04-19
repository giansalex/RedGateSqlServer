SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocCrea]
@Cd_TD nvarchar(2),
@Descrip varchar(100),
@NCorto varchar(6),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipDoc where Cd_TD=@Cd_TD)
	set @msj = 'Tipo Documento ya existe'
else
begin
	insert into TipDoc(Cd_TD,Descrip,NCorto,Estado)
	values(@Cd_TD,@Descrip,@NCorto,1)

	if @@rowcount <= 0
	   set @msj = 'Tipo Documento no pudo ser ingresado'
end
print @msj
GO

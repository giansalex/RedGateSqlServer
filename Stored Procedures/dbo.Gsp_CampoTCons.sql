SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoTCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from CampoT)
	set @msj = 'No se encontro Campo Tipo'
else*/ 
begin 
	if(@TipCons=0)
		select * from CampoT
	else select Cd_TC+'  |  '+Nombre as CodNom, Cd_TC, Nombre from CampoT
end
print @msj
GO

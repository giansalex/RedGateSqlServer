SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_PaisCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Pais)
	set @msj = 'No se encontro pais'
else */	
begin
	if(@TipCons=0)
	  	select * from Pais
	else if(@TipCons=1)
		select Cd_Pais+'  |  '+Nombre,Cd_Pais,Nombre as CodNom from Pais where Estado=1
	else if(@TipCons=3)
		select Cd_Pais,Cd_Pais,Nombre from Pais where Estado=1
end
print @msj
GO

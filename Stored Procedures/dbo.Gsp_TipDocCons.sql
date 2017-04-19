SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from TipDoc)
	set @msj = 'No se encontro Tipo Documento'
else */ 
begin
	if (@TipCons=0)
		select Cd_TD,Descrip,NCorto,Estado from TipDoc 
	else select Cd_TD+'  |  '+Descrip as CodNom, Cd_TD,Descrip from TipDoc where Estado=1 
	
end
print @msj
GO

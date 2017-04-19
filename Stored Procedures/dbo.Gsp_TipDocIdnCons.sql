SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocIdnCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from TipDocIdn)
	set @msj = 'No se encontro Tipo Documento Identidad'
else*/	
begin
	if(@TipCons=0)
		select * from TipDocIdn
	else select Cd_TDI,Cd_TDI+'  |  '+Descrip as CodNom,NCorto from TipDocIdn
	
end
print @msj

--MP : 15/05/2012 : <Modificacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as 
/*if not exists (select top 1 * from Serie where RucE=@RucE)
	set @msj = 'No se encontro Serie'
else*/
begin	
	if(@TipCons=0)
		select s.RucE,s.Cd_Sr,s.Cd_TD,t.Descrip,s.NroSerie,s.PtoEmision  from Serie s, TipDoc t where RucE=@RucE and s.Cd_TD=t.Cd_TD
	else select s.Cd_Sr+'  |  '+s.NroSerie as CodNom,s.Cd_Sr,s.NroSerie from Serie s, TipDoc t where RucE=@RucE and s.Cd_TD=t.Cd_TD
end
print @msj
GO

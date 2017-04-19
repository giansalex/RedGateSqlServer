SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NumeracionCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
/*if not exists (select top 1 * from Numeracion where RucE=@RucE)
	set @msj = 'No se encontro numeracion'
else	*/
	select 
		n.RucE, n.Cd_Num,
		s.Cd_TD, t.Descrip,
		s.Cd_Sr, s.NroSerie,
		n.Desde, n.Hasta, n.NroAutSunat
	from Numeracion n, Serie s, TipDoc t
	where n.RucE=@RucE and n.RucE=s.RucE and n.Cd_Sr=s.Cd_Sr and s.Cd_TD=t.Cd_TD
print @msj
GO

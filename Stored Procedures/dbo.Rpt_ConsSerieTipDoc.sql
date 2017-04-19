SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ConsSerieTipDoc] @RucE varchar(11),@Cd_TD nchar(2),@msj nvarchar (100) output
as
if not exists(select * from Serie s inner join Numeracion n on n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr where s.RucE = @RucE and s.Cd_TD = @Cd_TD)
begin
	set @msj = 'No existen series para este tipo de documento'
end
else
begin
select s.Cd_Sr,s.NroSerie from 
Serie s
left join TipDoc t on t.Cd_TD = s.Cd_TD
inner join Numeracion n on n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr
where s.RucE = @RucE and t.Cd_TD = @Cd_TD
end

--<creacion <30/10/2012>: Javier>
--Consulta para la pantalla del designer
--Rpt_ConsSerieTipDoc '20101588930','01',null
GO

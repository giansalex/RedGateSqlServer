SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_ConsTipDoc] @RucE varchar(11), @msj varchar(100) output
as 
if not exists (select * from Serie s inner join Numeracion n on n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr where s.RucE = @RucE)
begin
 set @msj = 'No existen documentos con serie creados.'
end
else
begin
select distinct s.RucE,s.Cd_TD,t.NCorto,t.Descrip
from 
Serie s 
inner join Numeracion n on n.RucE = s.RucE and n.Cd_Sr = s.Cd_Sr
left join TipDoc t on t.Cd_TD = s.Cd_TD
where s.RucE = @RucE
end

--<creacion <30/10/2012>: Javier>
--Consulta para la pantalla del designer
--Rpt_ConsTipDoc '20101588930',null
GO

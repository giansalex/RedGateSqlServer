SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_OrdFabricacion]
--declare 
@RucE nvarchar(11),
@Cd_Fab nvarchar(11)
as
--set @RucE = '20538728757'
--set @Cd_Fab = 'FAB0000002'

declare @Sql nvarchar(max)
set @Sql = '
select 
ff.*,
p.*,
ISNULL(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) as Cliente,
c.NDoc,
c.Cd_TDI,
tdi.NCorto,
tdi.Descrip
from FabFabricacion ff
left join Producto2 p on p.RucE = ff.RucE and p.Cd_Prod = ff.Cd_Prod
left join Cliente2 c on c.RucE = ff.RucE and c.Cd_Clt = ff.Cd_Clt
left join TipDocIdn tdi on tdi.Cd_TDI = c.Cd_TDI
where ff.RucE = '''+@RucE+''' and ff.Cd_Fab in ('+@Cd_Fab+''')'
print(@Sql)
exec(@Sql)
--<Creado: JA> <01/02/2013>
--Rpt_OrdFabricacion '20538728757','''FAB0000002'''
GO

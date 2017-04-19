SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_AmarreRptCons]
@msj varchar(100) output
as
/* if not exists (select top 1 * from AmarreRpt)
	set @msj = 'No se encontro relaciones'
else*/	select * from AmarreRpt
print @msj
GO

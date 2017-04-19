SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RubrosRptCons]
@msj varchar(100) output
as
/*if not exists (select top 1 * from RubrosRpt)
	set @msj = 'No se encontro Rubro'
else*/ select * from RubrosRpt
print @msj
GO

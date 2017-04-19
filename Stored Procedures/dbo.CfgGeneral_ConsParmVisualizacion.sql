SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CfgGeneral_ConsParmVisualizacion]
@RucE varchar(11),
@estado bit output
as
select @estado = ISNULL(IB_EjerAnt, 0) from CfgGeneral where RucE = @RucE
GO

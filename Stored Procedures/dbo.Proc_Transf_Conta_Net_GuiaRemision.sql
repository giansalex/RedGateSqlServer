SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[Proc_Transf_Conta_Net_GuiaRemision]
@RucE nvarchar(11)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into GuiaRemision 
	select *, 0 as IB_Anulado from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.GuiaRemision where RucE='''''+@RucE+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

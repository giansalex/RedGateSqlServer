SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_Conta_Net_TipDoc]
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into TipDoc 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.TipDoc'')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

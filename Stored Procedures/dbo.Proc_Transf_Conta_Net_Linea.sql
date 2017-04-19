SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_Conta_Net_Linea]
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into Linea 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.Linea'')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

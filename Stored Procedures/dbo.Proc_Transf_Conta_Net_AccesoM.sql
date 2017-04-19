SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_Conta_Net_AccesoM]
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into AccesoM 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.AccesoM'')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

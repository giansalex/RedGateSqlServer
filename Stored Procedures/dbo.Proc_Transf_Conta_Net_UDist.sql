SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_Conta_Net_UDist]
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into UDist 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.UDist'')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_Conta_Net_PrecioSrv]
@RucE nvarchar(11)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into PrecioSrv 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.PrecioSrv where RucE='''''+@RucE+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

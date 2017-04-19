SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[Proc_Transf_Conta_Net_CfgAutsXUsuario]
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into CfgAutsXUsuario 
	select * from OPENROWSET(''SQLOLEDB'',''ContaServer'';''User321'';''nomeacuerdo'',
		 ''select * from dbo.CfgAutsXUsuario'') where id_niv in (select id_niv from CfgNivelAut)'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

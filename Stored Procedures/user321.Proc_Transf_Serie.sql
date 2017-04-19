SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Serie]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)

set @Consulta='
insert into Serie(RucE,Cd_Sr,Cd_TD,NroSerie,PtoEmision)
	SELECT 
		RucE, Cd_Sr, Cd_TD, NroSerie, PtoEmision 
	from 
		OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
		''SELECT 
			RucE, Cd_Sr, Cd_TD, NroSerie, PtoEmision
		 from 
			dbo.Serie where RucE='''''+@RucE+''''' '')  
	Where 
		Cd_Sr not in (select Cd_Sr from Serie where RucE='''+@RucE+''')
'
Print @Consulta
exec (@Consulta)
--[user321].[Proc_Transf_Serie] '11111111111'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

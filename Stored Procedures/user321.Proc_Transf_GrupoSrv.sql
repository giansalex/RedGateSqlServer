SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_GrupoSrv]
@RucE  nvarchar(11)
as

declare @Consulta varchar(4000)

--delete GrupoSrv where RucE=@RucE

set @Consulta='
insert into GrupoSrv(RucE,Cd_GS,Descrip,NCorto,Estado)
	SELECT RucE,Cd_GS,Descrip,NCorto,Estado from OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
		  ''SELECT 
			RucE,Cd_GS,Descrip,NCorto,Estado
		   from 
			dbo.GrupoSrv where RucE='''''+@RucE+''''' '')
	where Cd_GS not in (select Cd_GS from GrupoSrv where RucE='''+@RucE+''')
'
print @Consulta
exec(@Consulta)
GO

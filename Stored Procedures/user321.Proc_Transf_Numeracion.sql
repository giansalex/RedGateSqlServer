SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Numeracion]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)

set @Consulta='
insert into Numeracion(RucE,Cd_Num,Cd_Sr,Desde,Hasta,NroAutSunat)
	SELECT RucE, Cd_Num, Cd_Sr, Desde, Hasta, NroAutSunat from OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
		''SELECT 
			RucE, Cd_Num, Cd_Sr, Desde, Hasta, NroAutSunat
	  	from 
			dbo.Numeracion where RucE='''''+@RucE+''''' '')
	where Cd_Num not in(Select Cd_Num from Numeracion where RucE='''+@RucE+''')
'
print @Consulta
exec (@Consulta)
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

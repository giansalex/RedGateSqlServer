SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Area]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)

--delete Area Where RucE=@RucE
set @Consulta='
--delete Area where RucE='''+@RucE+'''

insert into Area(RucE,Cd_Area,Descrip,NCorto,Estado)
	SELECT RucE, Cd_Area, Descrip, NCorto,Estado from OPENROWSET(''SQLOLEDB'',
 		  ''netserver'';''Usu123_1'';''user123'',
		  ''SELECT RucE, Cd_Area, Descrip, NCorto,Estado 
		   from dbo.Area where RucE='''''+@RucE+''''' '') 
	Where Cd_Area  not in (Select Cd_Area from Area where RucE='''+@RucE+''')
'
print @Consulta
exec(@Consulta)
--[user321].[Proc_Transf_Area] '11111111111'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

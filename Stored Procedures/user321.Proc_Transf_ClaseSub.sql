SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_ClaseSub]
as
declare @RucE nvarchar(11)

set @RucE='20266194324'


insert into ClaseSub(RucE,Cd_Cl,Cd_CLS,Nombre,NCorto,Estado,CA01,CA02)
	SELECT RucE,Cd_Cl,Cd_CLS,Nombre,NCorto,Estado,CA01,CA02
	    from OPENROWSET('SQLOLEDB',
	    'DataServer';'User123';'user123',
	    'SELECT RucE,Cd_Cl,Cd_CLS,Nombre,NCorto,Estado,CA01,CA02
	     from dbo.ClaseSub where RucE=''20266194324''')
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

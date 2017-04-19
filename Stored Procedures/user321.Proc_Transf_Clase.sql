SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Clase]
as
declare @RucE nvarchar(11)

set @RucE='20266194324'

insert into Clase(RucE,Cd_Cl,Nombre,NCorto,Estado,CA01,CA02)
	SELECT RucE, Cd_Cl, Nombre, NCorto, Estado,CA01,CA02 from OPENROWSET('SQLOLEDB',
 	'netserver';'Usu123_1';'user123',
	'SELECT RucE, Cd_Cl, Nombre, NCorto, Estado,CA01,CA02
	 from dbo.Clase where RucE=''20266194324''')
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

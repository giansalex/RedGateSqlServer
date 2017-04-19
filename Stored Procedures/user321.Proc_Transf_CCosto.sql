SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_CCosto]
@RucE nvarchar(11)
as

--delete CCSubSub where RucE=@RucE
--delete CCSub where RucE=@RucE
--delete CCostos where RucE=@RucE

declare @Consulta varchar(4000)

set @Consulta='
--delete CCSubSub where RucE='''+@RucE+'''
--delete CCSub where RucE='''+@RucE+'''
--delete ccostos where RucE='''+@RucE+'''

insert into CCostos(RucE,Cd_CC,Descrip,NCorto,IB_Psp)
	SELECT RucE, Cd_CC, Descrip, NCorto,0 IB_Psp from OPENROWSET(''SQLOLEDB'',
		 ''netserver'';''Usu123_1'';''user123'',
		 ''SELECT 
			RucE, 
			Cd_CC, 
			Descrip, 
			NCorto 
		  FROM 
			dbo.Ccostos 
		  where 
			RucE='''''+@RucE+''''' '')
		where Cd_CC not in(select Cd_CC from Ccostos where RucE='''+@RucE+''')
 '
print @Consulta
exec(@Consulta)
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
--user321.Proc_Transf_CCosto '11111111111'
GO

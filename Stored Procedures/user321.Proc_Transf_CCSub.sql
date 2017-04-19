SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_CCSub]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)
--delete CCSubSub where RucE=@RucE
--delete CCsub where RucE=@RucE

set @Consulta='
Delete dbo.CCSubSub where ruce='''+ @RucE+'''
DELETE dbo.CCSUB WHERE RUCE='''+@RucE+''' 

insert into CCsub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp)
	SELECT RucE, Cd_CC, Cd_SC, Descrip, NCorto,0 IB_Psp from OPENROWSET(''SQLOLEDB'',
 		''netserver'';''Usu123_1'';''user123'',
		''SELECT 
			RucE,
			Cd_CC, 
			Cd_SC, 
			Descrip, 
			NCorto 
		 from 
			dbo.CCsub 
		where
			RucE='''''+@RucE+''''' '')
	 '
print @Consulta
exec (@Consulta)
--user321.Proc_Transf_CCSub '20513272848'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

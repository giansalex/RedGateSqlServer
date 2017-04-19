SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_CCSubSub]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)

--delete CCSubSub Where RucE=@RucE

set @Consulta='
delete CCSubSub where ruce='''+@RucE+'''

insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp)
	SELECT RucE, Cd_CC, Cd_SC, Cd_SS, Descrip, NCorto, 0 IB_Psp
	    from OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
	   ''SELECT 
		RucE,
		Cd_CC, 
		Cd_SC, 
		Cd_SS, 
		Descrip, 
		NCorto 
           	    from 
		dbo.CCSubSub 
	   where 
		RucE='''''+@RucE+''''' '')
	'
Print @Consulta
Exec(@Consulta)

--exec user321.Proc_Transf_CCSubSub '20513272848'
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO

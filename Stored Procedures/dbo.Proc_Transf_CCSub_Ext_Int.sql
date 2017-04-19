SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_CCSub_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = '
	delete CCSubSub where RucE='''+@RucE+'''
	delete CCSub where RucE='''+@RucE+'''
	
	insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp)
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	''select 
		'''''+@RucE+''''',Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp
	from 
		CCSub 
	where RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>
GO

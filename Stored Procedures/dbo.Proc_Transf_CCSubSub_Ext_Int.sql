SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_CCSubSub_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = '
	delete CCSubSub where ruce='''+@RucE+'''
	insert into CCSubSub (RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp)
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	''select '''''+@RucE+''''',Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp 
	from CCSubSub where RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

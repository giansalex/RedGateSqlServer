SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[Proc_Transf_ClaseSubSub_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = '
	delete ClaseSubSub where ruce='''+@RucE+'''
	insert into ClaseSubSub 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
		 ''select 
				'''''+@RucE+''''',Cd_CL,Cd_CLS,Cd_CLSS,Nombre,NCorto,Estado,CA01,CA02
		   from ClaseSubSub where RucE='''''+@RucEBase+''''' '')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

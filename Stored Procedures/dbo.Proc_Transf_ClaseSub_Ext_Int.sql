SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [dbo].[Proc_Transf_ClaseSub_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = '
	delete ClaseSubSub where ruce='''+@RucE+'''
	delete ClaseSub where ruce='''+@RucE+'''
	
	insert into ClaseSub 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
		 ''select '''''+@RucE+''''',Cd_CL,Cd_CLS,Nombre,NCorto,Estado,CA01,CA02
		  from ClaseSub where RucE='''''+@RucEBase+''''' '')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

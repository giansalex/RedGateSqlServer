SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Clase_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = '
	delete ClaseSubSub where ruce='''+@RucE+'''
	delete claseSub where ruce='''+@RucE+'''
	delete Clase where ruce='''+@RucE+'''
	insert into Clase 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
		 ''select '''''+@RucE+''''',Cd_CL,Nombre,NCorto,Estado,CA01,CA02 from Clase where RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

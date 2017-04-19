SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[Proc_Transf_ComisionGrupCte_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into ComisionGrupCte 
	select * 
	from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
		 ''select '''''+@RucE+''''',Cd_CGC,Descrip,Estado from dbo.ComisionGrupCte where RucE='''''+@RucEBase+''''' '')'
print @consulta
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

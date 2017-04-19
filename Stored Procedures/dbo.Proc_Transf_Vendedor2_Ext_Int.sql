SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Vendedor2_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into Vendedor2 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	''select 
		'''''+@RucE+''''',Cd_Vdr,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,Ubigeo,Direc,Telf1,Telf2,
		Correo,Cargo,Obs,Cd_CGV,Cd_Ct,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,
		CA10,UsuCrea,FecReg,UsuMdf,FecMdf,UsuVdr,Cd_Caja 
	from 
		Vendedor2 where RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

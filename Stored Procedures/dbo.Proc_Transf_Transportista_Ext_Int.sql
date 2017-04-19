SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Transportista_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into Transportista 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	''select 
		'''''+@RucE+''''',Cd_Tra,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,Ubigeo,Direc,
		Telf,LicCond,NroPlaca,McaVeh,Obs,Estado,CA01,CA02,CA03,CA04,CA05,UsuCrea,
		FecReg,UsuMdf,FecMdf
	from 
		Transportista where RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>
GO

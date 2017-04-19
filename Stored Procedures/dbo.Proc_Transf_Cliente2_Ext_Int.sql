SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Cliente2_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as
declare @consulta nvarchar(1000)
set @consulta = 'insert into Cliente2 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	''
	select 
		'''''+@RucE+''''',Cd_Clt,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2
		, Fax,Correo,PWeb,Obs,CtaCtb,DiasCbr,PerCbr,CtaCte,Cd_CGC,Estado,CA01,CA02,CA03,CA04,CA05
		, CA06,CA07,CA08,CA09,CA10,Cd_Aux,Cd_TClt,FecReg,UsuCrea,FecMdf,UsuMdf from dbo.Cliente2 
	where 
		RucE='''''+@RucEBase+''''''')'
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Proc_Transf_Proveedor2_Ext_Int '1111','11111111111','NetServer','usucontanet','quepasasinomeacuerdo'
CREATE procedure [dbo].[Proc_Transf_Proveedor2_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as

declare @consulta nvarchar(1000)
set @consulta = 'insert into Proveedor2 
	select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
		 ''
 select		'''''+@RucE+''''',Cd_Prv,Cd_TDI,NDoc,RSocial,ApPat,ApMat,Nom,Cd_Pais,CodPost,Ubigeo,Direc,Telf1,Telf2
		, Fax,Correo,PWeb,Obs,CtaCtb,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
		, IB_SjDet,Cd_TPrv,FecReg,UsuCrea,FecMdf,UsuMdf,Grupo,DiasCobro,LimiteCredito,CtasCrtes,PerCobro 
	from dbo.Proveedor2 where RucE='''''+@RucEBase+''''''')'
print @Consulta
exec (@consulta)
--PP/FL : 10/05/2011 <creacion de sp>

GO

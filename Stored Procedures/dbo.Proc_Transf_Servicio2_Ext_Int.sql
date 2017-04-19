SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Servicio2_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into Servicio2(RucE,Cd_Srv,CodCo,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,IC_TipServ,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_Srv,CodCo,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,IC_TipServ,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
    from
        Servicio2
    where
        RucE='''''+@RucEBase+''''' '')'
exec(@Consulta)
        
        
        
GO

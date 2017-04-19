SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ServProv_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into ServProv(RucE,Cd_Prv,Cd_Srv,CodigoAlt,DescripAlt,Obs,CA01,CA02,CA03)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_Prv,Cd_Srv,CodigoAlt,DescripAlt,Obs,CA01,CA02,CA03
    from
        ServProv
    where
        RucE='''''+@RucEBase+''''' '')'
exec(@Consulta)
        
        
        
GO

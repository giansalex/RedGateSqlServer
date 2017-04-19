SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ProdProv_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into ProdProv(RucE,Cd_Prv,Cd_Prod,ID_UMP,CodigoAlt,DescripAlt,Obs,Estado,CA01,CA02,CA03)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_Prv,Cd_Prod,ID_UMP,CodigoAlt,DescripAlt,Obs,Estado,CA01,CA02,CA03
    from
        ProdProv
    where
        RucE='''''+@RucEBase+''''' '')'
exec(@Consulta)
        
        
GO

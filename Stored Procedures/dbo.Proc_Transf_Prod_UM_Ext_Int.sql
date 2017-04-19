SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Prod_UM_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as

declare @consulta varchar(8000)
set @consulta = '
insert into Prod_UM(RucE,Cd_Prod,ID_UMP,Cd_UM,DescripAlt,Factor,PesoKg,Volumen)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_Prod,ID_UMP,Cd_UM,DescripAlt,Factor,PesoKg,Volumen
    from
        Prod_UM
    where
        RucE='''''+@RucEBase+''''' '')'
print @Consulta
exec(@Consulta)
        
GO

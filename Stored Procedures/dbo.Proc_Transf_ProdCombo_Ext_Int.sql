SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ProdCombo_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into ProdCombo(RucE,Cd_ProdB,Cd_ProdC,Descrip,Cant,ID_UMP,Estado)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_ProdB,Cd_ProdC,Descrip,Cant,ID_UMP,Estado
    from
        ProdCombo
    where
        RucE='''''+@RucEBase+''''' '')'
exec(@Consulta)
        
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ServProvPrecio_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into ServProvPrecio(RucE,ID_PrecSP,Cd_Prv,Cd_Srv,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Estado)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',ID_PrecSP,Cd_Prv,Cd_Srv,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Estado
    from
        ServProvPrecio
    where
        RucE='''''+@RucEBase+''''' '')'

exec(@Consulta)
        
        
        
GO

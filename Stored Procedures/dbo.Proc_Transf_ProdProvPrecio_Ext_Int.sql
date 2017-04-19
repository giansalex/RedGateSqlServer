SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_ProdProvPrecio_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into ProdProvPrecio(RucE,ID_PrecPrv,Cd_Prv,Cd_Prod,ID_UMP,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Obs,Estado)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',ID_PrecPrv,Cd_Prv,Cd_Prod,ID_UMP,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Obs,Estado
    from
        ProdProvPrecio
    where
        RucE='''''+@RucEBase+''''' '')'
exec(@Consulta)
        
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Producto2_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as



declare @consulta varchar(8000)
set @consulta = '
insert into Producto2(RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,CodCo1_,CodCo2_,CodCo3_,CodBarras,FecCaducidad,Img,StockMin,StockMax,StockAlerta,StockActual,StockCot,StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF)
    select * from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select
        '''''+@RucE+''''',Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,CodCo1_,CodCo2_,CodCo3_,CodBarras,FecCaducidad,Img,StockMin,StockMax,StockAlerta,StockActual,StockCot,StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF
    from
        Producto2
    where
        RucE='''''+@RucEBase+''''' '')'
exec (@Consulta)
        
GO

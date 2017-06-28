SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_Producto2Mdf5]

@RucE nvarchar(11),
@Cd_Prod char(7),
@Nombre1  varchar(100),
@Nombre2 varchar(100),
@Descrip varchar(200),
@NCorto varchar(10),
@Cta1 varchar(10),
@Cta2 varchar(10),
@Cta3 varchar(10),
@Cta4 varchar(10),
@Cta5 varchar(10),
@Cta6 varchar(10),
@Cta7 varchar(10),
@Cta8 varchar(10),
@CodCo1_ varchar(20),
@CodCo2_ varchar(20),
@CodCo3_ varchar(20),
@CodBarras varchar(30),
@FecCaducidad smalldatetime,
@Img image,
@StockMin numeric(13,3),
@StockMax numeric(13,3),
@StockAlerta numeric(13,3),
@StockActual numeric(13,3),
@StockCot numeric(13,3),
@StockSol numeric(13,3),
@Cd_TE char(2),
@Cd_Mca char(3),
@Cd_CL char(3),
@Cd_CLS char(3),
@Cd_CLSS char(3),
@Cd_CGP char(3),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
--@UsuCrea varchar(50),
@UsuMdf varchar(50),
--@FecReg datetime,
--@FecMdf datetime,
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(300),
@CA10 varchar(300),
@IB_PT bit,
@IB_MP bit,
@IB_EE bit,
@IB_Srs bit,
@IB_PV bit,
@IB_PC bit,
@IB_AF bit,
@IB_TR bit,
@PagWeb varchar(300),
@msj varchar(100) output
as
if not exists (select * from Producto2 where RucE = @RucE and Cd_Prod=@Cd_Prod)
	set @msj = 'Producto no existe'
else
begin
	update Producto2 set Nombre1=@Nombre1,Nombre2=@Nombre2,Descrip=@Descrip,NCorto=@NCorto,Cta1=@Cta1,
		Cta2=@Cta2,Cta3=@Cta3,Cta4=@Cta4,Cta5=@Cta5,Cta6=@Cta6,Cta7=@Cta7,Cta8=@Cta8,CodCo1_=@CodCo1_,CodCo2_=@CodCo2_,CodCo3_=@CodCo3_,CodBarras=@CodBarras,
		FecCaducidad=@FecCaducidad,Img=@Img,StockMin=@StockMin,StockMax=@StockMax,StockAlerta=@StockAlerta,
		StockActual=@StockActual,StockCot=@StockCot,StockSol=@StockSol,Cd_TE=@Cd_TE,Cd_Mca=@Cd_Mca,
		Cd_CL=@Cd_CL,Cd_CLS=@Cd_CLS,Cd_CLSS=@Cd_CLSS,Cd_CGP=@Cd_CGP,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,
		UsuMdf=@UsuMdf,FecMdf=getdate(),Estado=@Estado,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,
		CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,IB_PT=@IB_PT,IB_MP=@IB_MP,
		IB_EE=@IB_EE,IB_Srs=@IB_Srs,IB_PV=@IB_PV,IB_PC=@IB_PC,IB_AF=@IB_AF, IB_TR = @IB_TR, PagWeb=@PagWeb
	where RucE = @RucE and Cd_Prod=@Cd_Prod  
	
	if @@rowcount <= 0
	set @msj = 'Producto no pudo ser modificado.'	
end
print @msj



-- Leyenda --
-- PP : 2010-02-23 : <Creacion del procedimiento almacenado>
-- PP : 2010-03-18 :  <Modificacion del procedimiento almacenado por centro  de costos>
-- FL : 2011-02-24 : <modificacion del procedimiento almacenado se agregaron los campos de IB_>
-- GS : 2017-05-22 : Add PageWeb to update product.



GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Producto2Crea5]

@RucE nvarchar(11),
@Cd_Prod char(7) output,
@Nombre1  varchar(100),
@Nombre2 varchar(100),
@Descrip varchar(200),
@NCorto varchar(10),
@Cta1 nvarchar(10),
@Cta2 nvarchar(10),
@Cta3 nvarchar(10),
@Cta4 nvarchar(10),
@Cta5 nvarchar(10),
@Cta6 nvarchar(10),
@Cta7 nvarchar(10),
@Cta8 nvarchar(10),
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
@UsuCrea varchar(50),
--@UsuMdf varchar(50),
--@FecReg datetime,
--@FecMdf datetime,
--@Estado bit,
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
set @Cd_Prod = dbo.Cod_Prod2(@RucE)

if exists (select * from Producto2 where RucE = @RucE and CodCo1_ = @CodCo1_)
	set @msj = 'Ya existe Producto con el mismo codigo comercial ingresado: ' + @CodCo1_
else
	begin
		
		insert into Producto2 (RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,Cta3,Cta4,Cta5,Cta6,Cta7,Cta8,CodCo1_,CodCo2_,CodCo3_,CodBarras,FecCaducidad,Img,
			StockMin,StockMax,StockAlerta,StockActual,StockCot,StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,
			UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF, IB_TR,PagWeb)
		     values(@RucE,@Cd_Prod,@Nombre1,@Nombre2,@Descrip,@NCorto,@Cta1,@Cta2,@Cta3,@Cta4,@Cta5,@Cta6,@Cta7,@Cta8,@CodCo1_,@CodCo2_,@CodCo3_,@CodBarras,@FecCaducidad,@Img,
			@StockMin,@StockMax,@StockAlerta,@StockActual,@StockCot,@StockSol,@Cd_TE,@Cd_Mca,@Cd_CL,@Cd_CLS,@Cd_CLSS,@Cd_CGP,
			@Cd_CC,@Cd_SC,@Cd_SS,@UsuCrea,null,getdate(),null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IB_PT,@IB_MP,@IB_EE,@IB_Srs,@IB_PV,@IB_PC,@IB_AF,@IB_TR,@PagWeb)
		if @@rowcount <= 0
			set @msj = 'Producto no pudo ser registrado.'	
	end
print @msj



-- Leyenda --
-- CAM : 14/01/2013 : <Creacion del procedimiento almacenado>
GO

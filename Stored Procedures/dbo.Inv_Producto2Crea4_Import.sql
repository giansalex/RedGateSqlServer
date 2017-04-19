SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Inv_Producto2Crea4_Import]

@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Prod char(7) output,
@Nombre1  varchar(100),
@Nombre2 varchar(100),
@Descrip varchar(200),
@NCorto varchar(10),
@Cta1 nvarchar(15),
@Cta2 nvarchar(15),
@Cta3 nvarchar(15),
@Cta4 nvarchar(15),
@Cta5 nvarchar(15),
@Cta6 nvarchar(15),
@Cta7 nvarchar(15),
@Cta8 nvarchar(15),
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
@msj varchar(100) output
as



/******* Validacion ****************/    /* GG */

if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@Cta1) and (isnull(@Cta1,'')<>'') --Se valida que el @Cta1 es un campo obligatorio
begin
	set @msj = 'No existe Cuenta Contable 1 ' +isnull(@Cta1,'Vacio')
	return
end

if not exists (select * from PlanCtas where RucE=@RucE  and Ejer=@Ejer and NroCta=@Cta2) and (isnull(@Cta2,'')<>'') --Se valida que el @Cta2 es un campo obligatorio
begin
	set @msj = 'No existe Cuenta Contable 2 ' +isnull(@Cta2,'Vacio')
	return
end



if not exists ( select * from TipoExistencia where Cd_TE=@Cd_TE) and  (isnull(@Cd_TE,'')<>'') 
begin
	set @msj = 'No existe Codigo Tipo de Existencia ' +isnull(@Cd_TE,'Vacio')
	return
end 



if not exists (select * from Marca where RucE=@RucE and Cd_Mca=@Cd_Mca) and  (isnull(@Cd_Mca,'')<>'') 
begin
	set @msj = 'No existe Codigo Marca ' +isnull(@Cd_Mca,'Vacio')
	return
end


  if not exists(select * from ComisionGrupProd where RucE=@RucE and Cd_CGP=@Cd_CGP)  and   (isnull(@Cd_CGP,'')<>'') 
  begin 
	set @msj = 'No existe Codigo Comision Grupo de Prod. ' +isnull(@Cd_CGP,'Vacio')
	return
		  
  end


--*************************************************************************************************************************
  set @msj= dbo.Valida_Clases(@RucE,@Cd_CL,@Cd_CLS,@Cd_CLSS)
 
  if(@msj<>'')
   begin
    return 
   end
  
  set @msj=dbo.Valida_CentrosDeCosto(@RucE,@Cd_CC,@Cd_SC,@Cd_SS)
  if(@msj<>'')
    begin
	return 
	end

/**********end Validacion ******************/


set @Cd_Prod = dbo.Cod_Prod2(@RucE)

if exists (select * from Producto2 where RucE = @RucE and CodCo1_ = @CodCo1_)
	set @msj = 'Ya existe Producto con el mismo codigo comercial ingresado: ' + @CodCo1_
else
	begin
		
		insert into Producto2 (RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,Cta3,Cta4,Cta5,Cta6,Cta7,Cta8,CodCo1_,CodCo2_,CodCo3_,CodBarras,FecCaducidad,Img,
			StockMin,StockMax,StockAlerta,StockActual,StockCot,StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,
			UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF, IB_TR)
		     values(@RucE,@Cd_Prod,@Nombre1,@Nombre2,@Descrip,@NCorto,@Cta1,@Cta2,@Cta3,@Cta4,@Cta5,@Cta6,@Cta7,@Cta8,@CodCo1_,@CodCo2_,@CodCo3_,@CodBarras,@FecCaducidad,@Img,
			@StockMin,@StockMax,@StockAlerta,@StockActual,@StockCot,@StockSol,@Cd_TE,@Cd_Mca,@Cd_CL,@Cd_CLS,@Cd_CLSS,@Cd_CGP,
			@Cd_CC,@Cd_SC,@Cd_SS,@UsuCrea,null,getdate(),null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IB_PT,@IB_MP,@IB_EE,@IB_Srs,@IB_PV,@IB_PC,@IB_AF,@IB_TR)
		if @@rowcount <= 0
			set @msj = 'Producto no pudo ser registrado.'	
	end
print @msj



-- Leyenda --
-- CAM : 14/01/2013 : <Creacion del procedimiento almacenado>
GO

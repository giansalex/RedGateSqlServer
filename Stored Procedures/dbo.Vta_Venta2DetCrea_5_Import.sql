SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Venta2DetCrea_5_Import]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Nro_RegVdt int,
--@Cd_Pro nvarchar(7),
@Cant numeric(16,7),
--@Cd_UM char(2),
@Valor numeric(16,7),
@DsctoP numeric(5,2),
@DsctoI numeric(16,7),
@IMP numeric(16,7),
@IGV numeric(16,7),
@Total numeric(16,7),
@CA01 varchar(300),
@CA02 varchar(300),
@CA03 varchar(50),
@CA04 varchar(50),
@CA05 varchar(50),
@CA06 varchar(50),
@CA07 varchar(50),
@CA08 varchar(50),
@CA09 varchar(50),
@CA10 varchar(50),
@UsuCrea nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_Prod char(7),
@Cd_Srv char(7),
@Descrip varchar(200),
@ID_UMP int,
@PU numeric(16,7),
@Obs varchar(300),
@Cd_Alm varchar(20),
@Cd_IAV char(1),
@PercepP numeric(8,7),
@PercepI numeric(16,7),
@TotalNeto numeric(16,7),

@msj varchar(100) output,
@CU numeric(16,7),
@Costo numeric(16,7),
@CU_ME numeric(16,7),
@Costo_ME numeric(16,7),
@UsuMdfCostoPrm nvarchar(10),
@ValVtaUnit numeric(18,7) = 0,
@TotalVtaSD numeric(20,7) = 0,
@PrecioUnitSD numeric(18,7) = 0
as

/******************* Start Validaciones *************************/

if not exists(select * from Almacen   where RucE=@RucE and Cd_Alm=@Cd_Alm) and (ISNULL(@Cd_Alm,' ')<> ' ') 
begin
	Set @msj='No existe Codigo de Almace  '+@Cd_Alm
	return
end 



	set @msj=dbo.Valida_CentrosDeCosto(@RucE,@Cd_CC,@Cd_SC,@Cd_SS)
	if(@msj<>'')
		 begin
			return 
		 end


if not exists(select * from IndicadorAfectoVta  where Cd_IAV=@Cd_IAV) and (ISNULL(@Cd_IAV,' ')<> ' ') 
begin
	Set @msj='No existe Codigo de Indicador Afecto Venta  '+@Cd_IAV
	return
end 

if not exists(select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP) and (isnull(@Cd_Prod, '') <> '') and (isnull(@ID_UMP, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Unid. Medida Producto ' + @Cd_Prod + ' | ' + CONVERT(varchar(6),@ID_UMP) 
		return 
	end


if not exists(select * from Producto2 where RucE=@RucE and Cd_Prod=@Cd_Prod) and (isnull(@Cd_Prod, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Producto ' + @Cd_Prod  
		return 
	end


if not exists(select * from Servicio2 where RucE=@RucE and Cd_Srv=@Cd_Srv) and (isnull(@Cd_Srv, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Servicio ' + @Cd_Srv  
		return 
	end


--if not exists(select * from UnidadMedida where Cd_UM=@c) and (isnull(@Cd_Vta, '') <> '') 
--	begin
--		Set @msj = 'No existe codigo de Venta ' + @Cd_Vta
--		return 
--	end

if not exists(select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta) and (isnull(@Cd_Vta, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Venta ' + @Cd_Vta
		return 
	end






/******************* End Validaciones *****************************/

if exists(select * from VentaDet where RucE=@RucE and Nro_RegVdt=@Nro_RegVdt  and Cd_Vta=@Cd_Vta)
	Set @msj = 'Ya existe numero de detalle de Venta'
else
begin
set @Nro_RegVdt=dbo.Nro_RegVdt(@RucE,@Cd_Vta)
	insert into VentaDet(RucE,Cd_Vta,Nro_RegVdt,Cd_Pro_NO,Cant,Valor,DsctoP,DsctoI,IMP,IGV,Total,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,
			     FecReg,UsuCrea,Cd_CC,Cd_SC,Cd_SS,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Obs,Cd_Alm,Cd_IAV,CU, Costo,CU_ME, Costo_ME,UsuMdfCostoPrm,ValVtaUnit,TotalVtaSD,PrecioUnitSD,PercepPorc,PercepImporte,TotalNeto)
		      values(@RucE,@Cd_Vta,@Nro_RegVdt,null,@Cant,@Valor,@DsctoP,@DsctoI,@IMP,isnull(@IGV,0.00),@Total,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,
			     GETDATE(),@UsuCrea,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Obs,@Cd_Alm,@Cd_IAV,@CU,@Costo,@CU_ME,@Costo_ME,@UsuMdfCostoPrm,@ValVtaUnit,@TotalVtaSD,@PrecioUnitSD,isnull(@PercepP,0),isnull(@PercepI,0),@TotalNeto)
	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle de Venta'
end
-- Leyenda --
-- CAM: 24/05/2012 agregue @UsuMdfCostoPM
-- AC: 13/03/2013 agregue 3 caqmpos de percepciones
GO

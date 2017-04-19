SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Venta2DetCrea_3]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Nro_RegVdt int,
--@Cd_Pro nvarchar(7),
@Cant numeric(13,3),
--@Cd_UM char(2),
@Valor numeric(13,2),
@DsctoP numeric(5,2),
@DsctoI numeric(13,2),
@IMP numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
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
@PU numeric(13,2),
@Obs varchar(300),
@Cd_Alm varchar(20),
@Cd_IAV char(1),

@msj varchar(100) output,
@CU numeric(13,2),
@Costo numeric(13,2),
@CU_ME numeric(13,2),
@Costo_ME numeric(13,2),
@UsuMdfCostoPrm nvarchar(10)
as
if exists(select * from VentaDet where RucE=@RucE and Nro_RegVdt=@Nro_RegVdt  and Cd_Vta=@Cd_Vta)
	Set @msj = 'Ya existe numero de detalle de Venta'
else
begin
set @Nro_RegVdt=dbo.Nro_RegVdt(@RucE,@Cd_Vta)
	insert into VentaDet(RucE,Cd_Vta,Nro_RegVdt,Cd_Pro_NO,Cant,Valor,DsctoP,DsctoI,IMP,IGV,Total,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,
			     FecReg,UsuCrea,Cd_CC,Cd_SC,Cd_SS,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Obs,Cd_Alm,Cd_IAV,CU, Costo,CU_ME, Costo_ME,UsuMdfCostoPrm)
		      values(@RucE,@Cd_Vta,@Nro_RegVdt,null,@Cant,@Valor,@DsctoP,@DsctoI,@IMP,isnull(@IGV,0.00),@Total,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,
			     GETDATE(),@UsuCrea,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Obs,@Cd_Alm,@Cd_IAV,@CU,@Costo,@CU_ME,@Costo_ME,@UsuMdfCostoPrm)
	if @@rowcount <= 0
	Set @msj = 'Error al registrar detalle de Venta'
end
-- Leyenda --
-- CAM: 24/05/2012 agregue @UsuMdfCostoPM
GO

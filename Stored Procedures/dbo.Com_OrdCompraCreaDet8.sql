SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraCreaDet8]
@RucE nvarchar(11),
@Cd_OC char(10),
@Item int,
@Cd_Prod char(7),
@Cd_Srv char(7),
@Descrip varchar(200),
@ID_UMP int,
@PU numeric(15,7),
@Cant numeric(20,10),
@Valor numeric(15,7),
@DsctoP numeric(5,2),
@DsctoI numeric(15,7),
@BIM numeric(15,7),
@IGV numeric(15,7),
@Total numeric(15,7),
@PendRcb numeric(13,3),
@Cd_Alm varchar(20),
@Obs varchar(5000),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 nvarchar(100),
@CA02 nvarchar(100),
@CA03 nvarchar(100),
@CA04 nvarchar(100),
@CA05 nvarchar(100),
@Cd_SCo char(10),
@ItemSC int,
@msj varchar(100) output,
@BIMTot numeric(15,7),
@IGVTot numeric(15,7)
as


if exists (select * from OrdCompraDet where RucE=@RucE and Item=@Item and Cd_OC=@Cd_OC)
	Set @msj = 'Ya existe numero de detalle de orden de compra' 

else
begin 
	Set @Item = dbo.ItemOCD(@RucE,@Cd_OC)	
	insert into OrdCompraDet(RucE,Cd_OC,Item,Cd_Prod,Cd_Srv,Descrip,ID_UMP,PU,Cant,Valor,DsctoP,DsctoI,
				BIM,IGV,Total,PendRcb,Cd_Alm,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05,IB_AtSrv,Cd_SCo,ItemSC,BIMTot,IGVTot)
			values(@RucE,@Cd_OC,@Item,@Cd_Prod,@Cd_Srv,@Descrip,@ID_UMP,@PU,@Cant,@Valor,@DsctoP,@DsctoI,
				@BIM,IsNull(@IGV,'0.00'),@Total,@PendRcb,@Cd_Alm,@Obs,@FecMdf,@UsuMdf,@CA01,@CA02,@CA03,
				@CA04,@CA05,0, @Cd_SCo, @ItemSC, @BIMTot, @IGVTot)--case(isnull(@Cd_Prod,0)) when 0 then 0 else null end)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar detalle orden de compra'
	
end
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>
-- JS : 2011-01-24 : <Modificacion del procedimiento almacenado>
-- CAM: 2011-08-19 : <Cambio a version 3><Se agrego la columna IB_AtSrv - para que se setee en cero>
-- KJ : 2012-07-24 : <Se cambio de 2 a 4 el valor de BIMTot e IGVTot>




GO

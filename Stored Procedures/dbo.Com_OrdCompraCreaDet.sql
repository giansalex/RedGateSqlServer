SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraCreaDet]

@RucE nvarchar(11),
@Cd_OC char(10),
@Item int,
@Cd_Prod char(7),
@Descrip varchar(200),
@ID_UMP int,
@PU numeric(13,4),
@Cant numeric(13,3),
@Valor numeric(13,4),
@DsctoP numeric(5,2),
@DsctoI numeric(13,4),
@BIM numeric(13,4),
@IGV numeric(13,4),
@Total numeric(13,2),
@PendRcb numeric(13,3),
@Cd_Alm varchar(20),
@Obs varchar(300),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 nvarchar(100),
@CA02 nvarchar(100),
@CA03 nvarchar(100),
@CA04 nvarchar(100),
@CA05 nvarchar(100),
@msj varchar(100) output

as


if exists (select * from OrdCompraDet where RucE=@RucE and Item=@Item and Cd_OC=@Cd_OC)
	Set @msj = 'Ya existe numero de detalle de orden de compra' 

else
begin 
	Set @Item = dbo.ItemOCD(@RucE,@Cd_OC)	
	insert into OrdCompraDet(RucE,Cd_OC,Item,Cd_Prod,Descrip,ID_UMP,PU,Cant,Valor,DsctoP,DsctoI,
				BIM,IGV,Total,PendRcb,Cd_Alm,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05)
			values(@RucE,@Cd_OC,@Item,@Cd_Prod,@Descrip,@ID_UMP,@PU,@Cant,@Valor,@DsctoP,@DsctoI,
				@BIM,IsNull(@IGV,'0.00'),@Total,@PendRcb,@Cd_Alm,@Obs,@FecMdf,@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar detalle orden de compra'
	
end
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO

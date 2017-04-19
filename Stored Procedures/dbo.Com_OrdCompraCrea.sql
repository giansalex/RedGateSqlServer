SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraCrea]

@RucE nvarchar(11),
@Cd_OC char(10) output,
@NroOC varchar(50),
@FecE smalldatetime,
@FecEntR smalldatetime,
@Cd_FPC nvarchar(2),
@Cd_Area nvarchar(6),
@Cd_Prv nvarchar(7),
@Obs varchar(1000),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2),
@ValorNeto numeric(13,4),
@DsctoFnzP numeric(5,2),
@DsctoFnzI numeric(13,2),
@BIM numeric(13,4),
@IGV numeric(13,2),
@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,2),
@IB_Aten bit,
--@AutorizadoPor varchar(100),
@Cd_SCo char(10),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
--@Id_EstOC char(2),
@CA01 nvarchar(100),
@CA02 nvarchar(100),
@CA03 nvarchar(100),
@CA04 nvarchar(100),
@CA05 nvarchar(100),
@CA06 nvarchar(100),
@CA07 nvarchar(100),
@CA08 nvarchar(100),
@CA09 nvarchar(300),
@CA10 nvarchar(300),
@msj varchar(100) output

as

Set @Cd_OC = dbo.Cd_OC(@RucE)	
if exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC and NroOC=@NroOC)
	Set @msj = 'Ya existe numero de orden de compra' 

else
begin 
	insert into OrdCompra(RucE,Cd_OC,NroOC,FecE,FecEntR,Cd_FPC,Cd_Area,Cd_Prv,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,
				DsctoFnzP,DsctoFnzI,BIM,IGV,Total,Cd_Mda,CamMda,IB_Aten,Cd_SCo,FecReg,UsuCrea,Cd_CC,
				Cd_SC,Cd_SS,Id_EstOC,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
			values(@RucE,@Cd_OC,@NroOC,@FecE,@FecEntR,@Cd_FPC,@Cd_Area,@Cd_Prv,IsNull(@Obs,''),@Valor,@TotDsctoP,@TotDsctoI,@ValorNeto,
				@DsctoFnzP,@DsctoFnzI,@BIM,IsNull(@IGV,0),@Total,@Cd_Mda,@CamMda,@IB_Aten,@Cd_SCo,getdate(),@UsuCrea,@Cd_CC,
				@Cd_SC,@Cd_SS,'01',@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar orden de compra'
end
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO

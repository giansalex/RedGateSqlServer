SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Com_OrdCompraCrea_3]

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
@CA11 nvarchar(100),
@CA12 nvarchar(100),
@CA13 nvarchar(100),
@CA14 nvarchar(100),
@CA15 nvarchar(100),
@TipAut int,
@Asunto varchar(200),
@msj varchar(100) output

as

Set @Cd_OC = dbo.Cd_OC(@RucE)	
if exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC and NroOC=@NroOC)
	Set @msj = 'Ya existe numero de Orden de Compra' 

else
begin 
	insert into OrdCompra(RucE,Cd_OC,NroOC,FecE,FecEntR,Cd_FPC,Cd_Area,Cd_Prv,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,
				DsctoFnzP,DsctoFnzI,BIM,IGV,Total,Cd_Mda,CamMda,IB_Aten,Cd_SCo,FecReg,UsuCrea,Cd_CC,
				Cd_SC,Cd_SS,Id_EstOC,Id_EstOCS,TipAut, IB_Aut, CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Asunto,CA11,CA12,CA13,CA14,CA15)
			values(@RucE,@Cd_OC,@NroOC,@FecE,@FecEntR,@Cd_FPC,@Cd_Area,@Cd_Prv,IsNull(@Obs,''),@Valor,@TotDsctoP,@TotDsctoI,@ValorNeto,
				@DsctoFnzP,@DsctoFnzI,@BIM,IsNull(@IGV,0),@Total,@Cd_Mda,@CamMda,@IB_Aten,@Cd_SCo,getdate(),@UsuCrea,@Cd_CC,
				@Cd_SC,@Cd_SS,'01','01',isnull(@TipAut,0),0,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Asunto,@CA11,@CA12,@CA13,@CA14,@CA15)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar Orden de Compra'
end
-- Leyenda --
-- MM : 2011-02-01 : <Modfdel procedimiento almacenado> : Se agrego campo de tipo autorizacion
-- DI : 2011-03-02 : <Se agrego la columna Asunto>
-- CAM : 2011-08-08 : <Se agrego la columna Id_EstOCS - Estados de Servicios>
GO

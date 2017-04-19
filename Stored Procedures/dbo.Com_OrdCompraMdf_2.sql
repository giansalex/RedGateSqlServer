SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraMdf_2]

@RucE nvarchar(11),--
@Cd_OC char(10),--
@NroOC varchar(50),--
@FecE smalldatetime,
@FecEntR smalldatetime,
@Cd_FPC nvarchar(2),
@Cd_Area nvarchar(6),
@Cd_Prv nvarchar(7),
@Obs varchar(1000),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2),
@ValorNeto numeric(13,2),
@DsctoFnzP numeric(5,2),
@DsctoFnzI numeric(13,2),
@BIM numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,2),
@IB_Aten bit,
@Cd_SCo char(10),
--@FecReg datetime,
--@FecMdf datetime,
--@UsuCrea nvarchar(10),
@UsuModf nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Id_EstOC char(2),
@AutdoPorN1 varchar(10),
--@AutdoPorN2 varchar(10),
--@AutdoPorN3 varchar(10),
@IC_NAut char(1),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@CA06 varchar(8000),
@CA07 varchar(8000),
@CA08 varchar(8000),
@CA09 varchar(8000),
@CA10 varchar(8000),
@CA11 varchar(8000),
@CA12 varchar(8000),
@CA13 varchar(8000),
@CA14 varchar(8000),
@CA15 varchar(8000),
@TipAut int,

@Asunto varchar(200),

@msj varchar(100) output

as

if not exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC and NroOC=@NroOC)
	Set @msj = 'Orden de Compra no existe' 

else
begin 
	update OrdCompra set FecE = @FecE,FecEntR = @FecEntR,Cd_FPC = @Cd_FPC,Cd_Area = @Cd_Area,Cd_Prv= @Cd_Prv, Obs = IsNull(@Obs,''),Valor = @Valor,
				TotDsctoP = @TotDsctoP,TotDsctoI = @TotDsctoI ,ValorNeto = @ValorNeto,
				DsctoFnzP = @DsctoFnzP,DsctoFnzI = @DsctoFnzI ,BIM = @BIM,IGV = @IGV,Total = @Total,Cd_Mda = @Cd_Mda,CamMda = @CamMda,
				IB_Aten = @IB_Aten,Cd_SCo = @Cd_SCo,FecMdf= getdate(),UsuModf =@UsuModf,Cd_CC = @Cd_CC,
				Cd_SC =@Cd_SC,Cd_SS = @Cd_SS,Id_EstOC = @Id_EstOC ,AutdoPorN1 = @AutdoPorN1, IC_NAut = @IC_NAut,TipAut = isnull(@TipAut,0), CA01 = @CA01,
				CA02 = @CA02, CA03 = @CA03,CA04 = @CA04,CA05 =@CA05, CA06 =@CA06,CA07 = @CA07,CA08 = @CA08,CA09 = @CA09 ,CA10 = @CA10,
				Asunto=@Asunto,CA11 = @CA11,CA12 = @CA12, CA13 = @CA13,CA14 = @CA14,CA15 =@CA15
			where RucE = @RucE and Cd_OC = @Cd_OC and NroOC = @NroOC
	if @@rowcount <= 0
		Set @msj = 'Error al modificar Orden de Compra'	
end
print @msj
-- Leyenda --
-- MM : 2011-02-01 : <Modf del procedimiento almacenado> : Se agrego el campo tipo de autorizacion
-- DI : 2011-03-02 ; <Se agrego la columna Asunto>
-- PP : 2011-07-14 ; <Se agrego la columna Asunto CA>

GO

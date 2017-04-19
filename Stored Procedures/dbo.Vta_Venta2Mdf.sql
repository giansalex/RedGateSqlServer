SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_Venta2Mdf]
@RucE nvarchar(11), --
@Cd_Vta nvarchar(10), -- 
@Eje nvarchar(4), --
@Prdo nvarchar(2), --
@RegCtb nvarchar(15), --
@FecMov smalldatetime, --
@Cd_FPC nvarchar(2), --
@FecCbr smalldatetime, --
@Cd_TD nvarchar(2), --
@NroDoc nvarchar(15), --
@FecED smalldatetime, --
@FecVD smalldatetime, --
@Cd_Clt char(10), --
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2), 
@ValorNeto numeric(13,2),
@BaseSinDsctoF numeric(13,2),
@DsctoFnz_P numeric(5,2),
@DsctoFnz_I numeric(13,2),
@Cd_IAV_DF char(1),
@INF_Neto numeric(13,2),
@EXO_Neto numeric(13,2), 
@EXPO_Neto numeric(13,2),
@BIM_Neto numeric(13,2),
@IGV numeric(13,2), 
@Total numeric(13,2), 
@Percep numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@UsuModf nvarchar(10),
@CA01 varchar(100), 
@CA02 varchar(100), 
@CA03 varchar(100), 
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(100),
@CA10 varchar(100),
@CA11 varchar(100),
@CA12 varchar(100),
@CA13 varchar(100),
@CA14 varchar(100),
@CA15 varchar(100),
@Cd_OP char(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@NroSre varchar(5),
@Cd_MIS char(3),
--Documento de Referencia
------------------------------
@DR_CdVta nvarchar(10),
@DR_FecED smalldatetime,
@DR_CdTD  nvarchar(2),
@DR_NSre  nvarchar(4),
@DR_NDoc  nvarchar(15),
------------------------------
@msj varchar(100) output

as


if not exists (select * from Venta where RucE = @RucE and Cd_Vta = @Cd_Vta)
	Set @msj = 'Venta no existe' 
else
begin
	if @UsuModf  not in ('pedro.delacruz','alvaro.miranda','eleon') and @RucE != '20504743561'

	begin
		if exists( select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta and UsuCrea !=@UsuModf)
		begin
				Set @msj = 'No tiene permisos para modificar la venta'
				return
		end
	end
	update 	Venta set 
	Eje=@Eje, 
	Prdo=@Prdo, 
	RegCtb=@RegCtb, 
	FecMov=@FecMov, 
	Cd_FPC=@Cd_FPC,  
	FecCbr=@FecCbr,
	Cd_TD=@Cd_TD, 
	NroDoc=@NroDoc, 
	FecED=@FecED, 
	FecVD=@FecVD, 
	Cd_Clt=@Cd_Clt,
	Cd_Vdr=@Cd_Vdr, 
	Cd_Area=@Cd_Area, 
	Cd_MR=@Cd_MR, 
	Obs=@Obs, 
	Valor = @Valor,
	TotDsctoP=@TotDsctoP, 
	TotDsctoI=@TotDsctoI,
	ValorNeto=@ValorNeto,
	BaseSinDsctoF=@BaseSinDsctoF,
	DsctoFnz_P=@DsctoFnz_P, 
	DsctoFnz_I=@DsctoFnz_I,
	Cd_IAV_DF=@Cd_IAV_DF,
	INF_Neto=@INF_Neto,
	EXO_Neto=@EXO_Neto,
	EXPO_Neto=@EXPO_Neto,  
	BIM_Neto=@BIM_Neto,
	IGV=@IGV,  
	Total=@Total,
	@Percep=@Percep, 
	Cd_Mda=@Cd_Mda, 
	CamMda=@CamMda, 
	UsuModf = @UsuModf, 
	--IB_Anulado=@IB_Anulado,  
	CA01=@CA01, 
	CA02=@CA02, 
	CA03=@CA03,
	CA04=@CA04, 
	CA05=@CA05, 
	CA06=@CA06, 
	CA07=@CA07, 
	CA08=@CA08, 
	CA09=@CA09, 
	CA10=@CA10, 
	CA11=@CA11, 
	CA12=@CA12,
	CA13=@CA13, 
	CA14=@CA14, 
	CA15=@CA15, 
	Cd_OP=@Cd_OP, 
	Cd_CC=@Cd_CC, 
	Cd_SC=@Cd_SC, 
	Cd_SS=@Cd_SS, 
	NroSre=@NroSre, 
	Cd_MIS=@Cd_MIS,
	FecMdf=Getdate(),
	--Documento de Referencia
	------------------------------ 
	DR_CdVta=@DR_CdVta,
	DR_FecED=@DR_FecED, 
	DR_CdTD=@DR_CdTD, 
	DR_NSre=@DR_NSre, 
	DR_NDoc=@DR_NDoc
	------------------------------
		where	RucE = @RucE and Cd_Vta = @Cd_Vta
		if @@rowcount <= 0
			Set @msj = 'Error al modificar Venta'	
	end

print @msj
-- Leyenda --
-- JJ : 2010-08-24 : <Creacion del procedimiento almacenado>
-- JU : 2010-07-10 : <Modificacion del Procedimiento Almacenado>

GO

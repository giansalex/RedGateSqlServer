SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Com_CompraCreaImport]
@RucE nvarchar(11),
@Cd_Com char(10) output,
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@RegCtb nvarchar(15),
@FecMov smalldatetime,
@Cd_FPC nvarchar(2),
@FecApag smalldatetime,
@Cd_TD nvarchar(2),
@NroSre varchar(5),
@NroDoc nvarchar(15),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_TDI_Prov varchar(2),
@NDoc_Prv varchar(15),
@Cd_Area nvarchar(6),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@BIM_S numeric(13,2),
@IGV_S numeric(13,2),
@BIM_E numeric(13,2),
@IGV_E numeric (13,2),
@BIM_C numeric (13,2),
@IGV_C numeric (13,2),
@Imp_N numeric (13,2),
@Imp_O numeric (13,0),
@Total numeric (13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@Cd_MIS char(3),
@Cd_OC char(10),
@FecMdf datetime,
@UsuCrea nvarchar(10),
@UsuModf nvarchar(10),
@DR_NCND varchar(15),
@DR_NroDet varchar(15),
@DR_FecDet smalldatetime,
@DR_CdCom char(10),
@DR_FecED smalldatetime,
@DR_CdTD varchar(2),
@DR_NSre varchar(5),
@DR_NDoc varchar(15),
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
@CA16 varchar(100),
@CA17 varchar(100),
@CA18 varchar(100),
@CA19 varchar(100),
@CA20 varchar(100),
@CA21 varchar(100),
@CA22 varchar(100),
@CA23 varchar(100),
@CA24 varchar(100),
@CA25 varchar(100),
@MovComCtb bit = null output,
@TipNC char(2),
@ImpDetr numeric (13,2),
@FecPagDtr datetime,
@msj varchar(100) output

as


declare @Cd_Prv char(7)
select @MovComCtb = IB_MovComCtbLin from CfgGeneral where RucE = @RucE
if @MovComCtb is null 
	set @MovComCtb =  0

	/**********************Start Validacion*****************/

	if not exists(select * from FormaPC where Cd_FPC=@Cd_FPC ) and (isnull(@Cd_FPC, '') <> '') 
	begin
		Set @msj = 'No existe Codigo de Forma de Pago : '+@Cd_FPC
		return 
	end

	if not exists(select * from TipDocIdn where Cd_TDI=@Cd_TDI_Prov ) and (isnull(@Cd_TDI_Prov, '') <> '') 
	begin
		Set @msj = 'No existe Tipo Documento de Identificacion : '+@Cd_TDI_Prov 
		return 
	end

	if not exists(select * from Proveedor2 where Cd_TDI=@Cd_TDI_Prov  and NDoc=@NDoc_Prv) and (isnull(@Cd_TDI_Prov, '') <> '')  and  (isnull(@NDoc_Prv, '') <> '')  
	begin
		Set @msj = 'No existe proveedor con Tipo documento '+@Cd_TDI_Prov+' y N° Documento '+@NDoc_Prv 
		return 
	end



	if not exists(select * from Moneda where Cd_Mda=@Cd_Mda ) and (isnull(@Cd_Mda, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Moneda : '+@Cd_Mda 
		return 
	end

	if not exists(select * from MtvoIngSal where RucE=@RucE and Cd_MIS=@Cd_MIS) and (isnull(@Cd_MIS, '') <> '') 
	begin
		Set @msj = 'No existe Cod Mot Ing Sal : '+@Cd_MIS 
		return 
	end

	if not exists(select * from TipDoc where Cd_TD=@Cd_TD ) and (isnull(@Cd_TD, '') <> '') 
	begin
		Set @msj = 'No existe codigo de Tipo de Documento : '+@Cd_TD 
		return 
	end

	
	if not exists(select * from Area where RucE=@RucE and Cd_Area=@Cd_Area ) and (isnull(@Cd_Area, '') <> '') 
	begin
		Set @msj = 'No existe codigo Area : '+@Cd_Area
		return 
	end


	if not exists(select * from Modulo where Cd_MR=@Cd_MR ) and (isnull(@Cd_MR, '') <> '') 
	begin
		Set @msj = 'No existe codigo Modulo de Registro : '+@Cd_MR
		return 
	end


	if not exists(select * from TipDoc where Cd_TD=@DR_CdTD ) and (isnull(@DR_CdTD, '') <> '') 
	begin
		Set @msj = 'No existe codigo Tipo de Documento Referencia : '+@DR_CdTD
		return 
	end

	  
	set @msj=dbo.Valida_CentrosDeCosto(@RucE,@Cd_CC,@Cd_SC,@Cd_SS)
	if(@msj<>'')
		 begin
			return 
		 end
	
	
	/******************************End Validacion*******************************************/


Set @Cd_Com = dbo.Cd_Com(@RucE)	
if exists (select * from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
	Set @msj = 'Ya existe codigo de compra' 
else if exists (select * from Compra where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	Set @msj = 'Ya existe registro contable en Compra'
else if exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	Set @msj = 'Ya existe registro contable en Voucher'
else if exists (select * from Compra where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_TD=@Cd_TD 
				       	and NroSre=@NroSre and NroDoc=@NroDoc)
	Set @msj = 'Ya existe numero de documento en Compra'
else if exists (select * from Voucher where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_TD=@Cd_TD 
				       	and NroSre=@NroSre and NroDoc=@NroDoc and Cd_Fte = 'RC')
	Set @msj = 'Ya existe numero de documento en Voucher'
else
begin 

set @Cd_Prv=(select Cd_Prv from Proveedor2 where RucE=@RucE and Cd_TDI=@Cd_TDI_Prov  and NDoc=@NDoc_Prv)
	insert into Compra(RucE,Cd_Com,Ejer,Prdo,RegCtb,FecMov,Cd_FPC,FecApag,Cd_TD,NroSre,NroDoc,FecED,FecVD,Cd_Prv,
			   Cd_Area,Cd_CC,Cd_SC,Cd_SS,Cd_MR,Obs,BIM_S,IGV_S,BIM_E,IGV_E,BIM_C,IGV_C,Imp_N,Imp_O,
			   Total,Cd_Mda,CamMda,Cd_MIS,Cd_OC,IB_Pgdo,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,DR_NCND,
			   DR_NroDet,DR_FecDet,DR_CdCom,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,CA01,CA02,CA03,CA04,CA05,CA06,
			   CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,CA16,CA17,CA18,CA19,CA20,CA21,CA22,CA23,CA24,CA25,TipNC,ImpDetr,FecPagDtr)
			values(@RucE,@Cd_Com,@Ejer,@Prdo,@RegCtb,@FecMov,@Cd_FPC,@FecApag,@Cd_TD,@NroSre,@NroDoc,@FecED,
			       @FecVD,@Cd_Prv,@Cd_Area,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_MR,@Obs,@BIM_S,@IGV_S,@BIM_E,@IGV_E,
			       @BIM_C,@IGV_C,@Imp_N,@Imp_O,@Total,@Cd_Mda,@CamMda,@Cd_MIS,@Cd_OC,0,getdate(),@FecMdf,@UsuCrea,
			       @UsuModf,0,@DR_NCND,@DR_NroDet,@DR_FecDet,@DR_CdCom,@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc,@CA01,
			       @CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15,@CA16,@CA17,@CA18,
			       @CA19,@CA20,@CA21,@CA22,@CA23,@CA24,@CA25, @TipNC,@ImpDetr,@FecPagDtr)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar compra'
	--exec pvo.Ctb_AsientoAutomatico  @RucE, @Ejer, @RegCtb, @Cd_MIS,@Cd_Com,@msj

end
-- Leyenda --
-- JJ : 2010-08-23 : <Creacion del procedimiento almacenado>
-- MP : 2010-11-16 : <Modificacion del procedimiento almacenado> 
-- MP : 2011-04-14 : <Modificacion del procedimiento almacenado> (MAS CAMPOS ADICIONALES)
-- CAM : 2011-11-07 : <Modificacion del procedimiento almacenado a nueva version(3)> (Se agrego la opcion de guardar TipNC)
-- JJ : 2012-03-08: <se agregaron columnas de detraccion>
GO

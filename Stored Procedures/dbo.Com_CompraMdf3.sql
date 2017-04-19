SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Com_CompraMdf3]
@RucE nvarchar(11),
@Cd_Com char(10),
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
@Cd_Prv char(7),
@Cd_Area nvarchar(6),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
--@Cd_IA char(1),
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
@IB_Pgdo bit,
--@FecReg datetime,
--@FecMdf datetime,
--@UsuCrea nvarchar(10),
@UsuModf nvarchar(10),
@IB_Anulado bit,
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
@TipNC char(2),

@msj varchar(100) output

as


declare @Cd_Prv_Ant char(7)
set @Cd_Prv_Ant = (select Cd_Prv from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
declare @Cd_TD_Ant nvarchar(2)
set @Cd_TD_Ant = (select Cd_TD from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
declare @NroSre_Ant varchar(5)
set @NroSre_Ant = (select NroSre from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
declare @NroDoc_Ant nvarchar(15)
set @NroDoc_Ant = (select NroDoc from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
declare @cambioLlave bit


if @Cd_Prv_Ant=@Cd_Prv and @Cd_TD_Ant=@Cd_TD and @NroSre_Ant=@NroSre and @NroDoc_Ant=@NroDoc
	set @cambioLlave = 0
else
	set @cambioLlave = 1


if not exists (select * from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
	Set @msj = 'No existe cÃƒÂ³digo de Compra' 
else if exists (select * from Compra where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_TD=@Cd_TD 
				       	and NroSre=@NroSre and NroDoc=@NroDoc) and @cambioLlave = 1
	Set @msj = 'Ya existe numero de documento en Compra'
else if exists (select * from Voucher where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_TD=@Cd_TD 
				       	and NroSre=@NroSre and NroDoc=@NroDoc) and @cambioLlave = 1
	Set @msj = 'Ya existe numero de documento en Voucher'
else
begin 


	update Compra set Ejer=@Ejer, Prdo=@Prdo, RegCtb=@RegCtb,FecMov=@FecMov, Cd_FPC=@Cd_FPC,FecApag=@FecApag, Cd_TD=@Cd_TD, NroSre=@NroSre, 
	NroDoc=@NroDoc, FecED=@FecED, FecVD=@FecVD, Cd_Prv=@Cd_Prv,Cd_Area=@Cd_Area, Cd_CC=@Cd_CC, Cd_SC=@Cd_SC, Cd_SS=@Cd_SS,
	Cd_MR=@Cd_MR, Obs=@Obs,BIM_S=@BIM_S, IGV_S=@IGV_S, BIM_E=@BIM_E, IGV_E=@IGV_E, BIM_C=@BIM_C, IGV_C=@IGV_C,
	Imp_N=@Imp_N, Imp_O=@Imp_O,Total=@Total, Cd_Mda=@Cd_Mda, CamMda=@CamMda, Cd_MIS=@Cd_MIS, Cd_OC=@Cd_OC, IB_Pgdo=@IB_Pgdo,
	FecMdf= getdate(), UsuModf=@UsuModf,IB_Anulado=@IB_Anulado, DR_NCND=@DR_NCND, DR_NroDet=@DR_NroDet, DR_FecDet=@DR_FecDet,
	DR_CdCom=@DR_CdCom, DR_FecED=@DR_FecED, DR_CdTD=@DR_CdTD, DR_NSre=@DR_NSre, DR_NDoc=@DR_NDoc, CA01=@CA01, CA02=@CA02, 
	CA03=@CA03, CA04=@CA04, CA05=@CA05, CA06=@CA06, CA07=@CA07, CA08=@CA08, CA09=@CA09, CA10=@CA10, CA11=@CA11, CA12=@CA12, 
	CA13=@CA13, CA14=@CA14, CA15=@CA15, CA16=@CA16, CA17=@CA17, CA18=@CA18, CA19=@CA19, CA20=@CA20, CA21=@CA21, CA22=@CA22,
	CA23=@CA23, CA24=@CA24, CA25=@CA25, TipNC = @TipNC
	where RucE = @RucE and Cd_Com = @Cd_Com
	if @@rowcount <= 0
		Set @msj = 'Error al modificar Compra'	
end
print @msj



-- Leyenda --
-- JJ : 2010-08-24 : <Creacion del procedimiento almacenado>
-- CAM : 2011-11-07 : <Modificacion del procedimiento almacenado a nueva version(3)> (Se agrego la opcion de guardar TipNC)





GO

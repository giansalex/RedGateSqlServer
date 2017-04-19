SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionModf]

@RucE	nvarchar(11),
@Cd_IP	char(7) output,
@NroImp	varchar(25),
@Ejer	nvarchar(4),
@FecMov	smalldatetime,
@Cd_Alm	varchar(20),
@Cd_Area	nvarchar(6),
@Asunto	varchar(200),
@Obs	varchar(1000),
@EXWT	numeric(13,2),
@EXWT_ME	numeric(13,2),
@ComT	numeric(13,2),
@ComT_ME	numeric(13,2),
@OtroET	numeric(13,2),
@OtroET_ME	numeric(13,2),
@FOBT	numeric(13,2),
@FOBT_ME	numeric(13,2),
@FleteT numeric(13,2),
@FleteT_ME numeric(13,2),
@SegT	numeric(13,2),
@SegT_ME	numeric(13,2),
@OtroFT	numeric(13,2),
@OtroFT_ME	numeric(13,2),
@CIFT	numeric(13,2),
@CIFT_ME	numeric(13,2),
@AdvT	numeric(13,2),
@AdvT_ME	numeric(13,2),
@OtroCT	numeric(13,2),
@OtroCT_ME	numeric(13,2),
@Total	numeric(13,2),
@Total_ME	numeric(13,2),
@RatioT	numeric(13,2),
@RatioT_ME	numeric(13,2),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
--@FecReg	datetime,
--@FecMdf	datetime,
--@UsuCrea	nvarchar(10),
@UsuModf	nvarchar(10),
@CA01	varchar(100),
@CA02	varchar(100),
@CA03	varchar(100),
@CA04	varchar(100),
@CA05	varchar(100),
@CA06	varchar(100),
@CA07	varchar(100),
@CA08	varchar(100),
@CA09	varchar(100),
@CA10	varchar(100),
@msj varchar(100) output
as

update Importacion
set 
NroImp = @NroImp,Ejer = @Ejer,FecMov = @FecMov,Cd_Alm = @Cd_Alm,Cd_Area = @Cd_Area,Asunto = @Asunto,Obs = @Obs,EXWT = @EXWT,ComT = @ComT,OtroET = @OtroET,FOBT = @FOBT,
FleteT = @FleteT,SegT = @SegT,OtroFT = @OtroFT,CIFT = @CIFT,AdvT = @AdvT,OtroCT = @OtroCT,Total = @Total,RatioT = @RatioT,EXWT_ME = @EXWT_ME,ComT_ME = @ComT_ME,
OtroET_ME = @OtroET_ME,FOBT_ME = @FOBT_ME,FleteT_ME = @FleteT_ME,SegT_ME = @SegT_ME,OtroFT_ME = @OtroFT_ME,CIFT_ME = @CIFT_ME,AdvT_ME = @AdvT_ME,
OtroCT_ME = @OtroCT_ME,Total_ME = @Total_ME,RatioT_ME = @RatioT_ME,Cd_CC = @Cd_CC,Cd_SC = @Cd_SC,Cd_SS = @Cd_SS,FecMdf = getdate(),UsuModf = @UsuModf,
CA01 = @CA01,CA02 = @CA02,CA03 = @CA03,CA04 = @CA04,CA05 = @CA05,CA06 = @CA06,CA07 = @CA07,CA08 = @CA08,CA09 = @CA09,CA10 = @CA10
where RucE = @RucE and Cd_IP = @Cd_IP

if @@rowcount <= 0
	set @msj = 'Importacion no pudo ser registrado'	
	
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionCrea]

@RucE	nvarchar(11),
@Cd_IP	char(7) output,
@NroImp	varchar(25),
@Ejer	nvarchar(4),
@FecMov	smalldatetime,
@Cd_Alm	varchar(20),
@Cd_Area	nvarchar(6),
@Asunto	varchar(200),
@Obs	varchar(1000),
@EXWT	numeric(13,4),
@EXWT_ME	numeric(13,4),
@ComT	numeric(13,4),
@ComT_ME	numeric(13,4),
@OtroET	numeric(13,4),
@OtroET_ME	numeric(13,4),
@FOBT	numeric(13,4),
@FOBT_ME	numeric(13,4),
@FleteT numeric(13,4),
@FleteT_ME numeric(13,4),
@SegT	numeric(13,4),
@SegT_ME	numeric(13,4),
@OtroFT	numeric(13,4),
@OtroFT_ME	numeric(13,4),
@CIFT	numeric(13,4),
@CIFT_ME	numeric(13,4),
@AdvT	numeric(13,4),
@AdvT_ME	numeric(13,4),
@OtroCT	numeric(13,4),
@OtroCT_ME	numeric(13,4),
@Total	numeric(13,4),
@Total_ME	numeric(13,4),
@RatioT	numeric(13,4),
@RatioT_ME	numeric(13,4),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
--@FecReg	datetime,
--@FecMdf	datetime,
@UsuCrea	nvarchar(10),
--@UsuModf	nvarchar(10),
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

set @Cd_IP = dbo.Cd_IP(@RucE)
insert into Importacion (RucE,Cd_IP,NroImp,Ejer,FecMov,Cd_Alm,Cd_Area,Asunto,Obs,EXWT,ComT,OtroET,FOBT,FleteT,SegT,OtroFT,CIFT,AdvT,OtroCT,Total,RatioT,EXWT_ME,ComT_ME,OtroET_ME,FOBT_ME,FleteT_ME,SegT_ME,OtroFT_ME,CIFT_ME,AdvT_ME,OtroCT_ME,Total_ME,RatioT_ME,Cd_CC,Cd_SC,Cd_SS,FecReg,UsuCrea,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
values (@RucE,@Cd_IP,@NroImp,@Ejer,@FecMov,@Cd_Alm,@Cd_Area,@Asunto,@Obs,@EXWT,@ComT,@OtroET,@FOBT,@FleteT,@SegT,@OtroFT,@CIFT,@AdvT,@OtroCT,@Total,@RatioT,@EXWT_ME,@ComT_ME,@OtroET_ME,@FOBT_ME,@FleteT_ME,@SegT_ME,@OtroFT_ME,@CIFT_ME,@AdvT_ME,@OtroCT_ME,@Total_ME,@RatioT_ME,@Cd_CC,@Cd_SC,@Cd_SS,GETDATE(),@UsuCrea,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
if @@rowcount <= 0
	set @msj = 'Importacion no pudo ser registrado'	
	
GO

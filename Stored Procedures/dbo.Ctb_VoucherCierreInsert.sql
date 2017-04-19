SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCierreInsert]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@RegCtb nvarchar(15),
@Cd_Fte varchar(2),
@FecMov smalldatetime,
@FecCbr smalldatetime,
@NroCta	nvarchar(10),
@Cd_TD	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc nvarchar(15),
@FecED smalldatetime,
@FecVD smalldatetime,
@Glosa varchar(200),
@MtoOr numeric(13,2),
@MtoD numeric(13,2),
@MtoH numeric(13,2),
@MtoD_ME numeric(13,2),    
@MtoH_ME numeric(13,2),
@Cd_MdOr nvarchar(2),
@Cd_MdRg nvarchar(2),
@CamMda numeric(6,3),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Cd_TG nvarchar(2),
@IC_CtrMd varchar(1),
@IC_TipAfec varchar(1),
@TipOper varchar(4),
@NroChke varchar(30),
@Grdo varchar(100),
@IB_EsProv bit,
@UsuCrea nvarchar(10),
@DR_FecED smalldatetime,
@DR_CdTD nvarchar(2),
@DR_NSre nvarchar(4),
@DR_NDoc nvarchar(15),
@DR_NCND varchar(15),
@DR_NroDet varchar(15),
@DR_FecDet smalldatetime,
@Cd_Clt	char(10),
@Cd_Prv	char(7)
as

declare @Cd_Vou Int
set @Cd_Vou=dbo.Cod_Vou(@RucE)
insert into voucher 
(RucE,Cd_Vou,Ejer,Prdo,RegCtb,Cd_Fte,FecMov,FecCbr,NroCta,Cd_TD,NroSre,NroDoc,FecED,FecVD,Glosa,MtoOr,MtoD,MtoH,MtoD_ME,MtoH_ME,Cd_MdOr,Cd_MdRg,
CamMda,Cd_CC,Cd_SC,Cd_SS,Cd_Area,Cd_MR,Cd_TG,IC_CtrMd,IC_TipAfec,TipOper,NroChke,Grdo,IB_EsProv,FecReg,UsuCrea,
DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,DR_NCND,DR_NroDet,DR_FecDet,Cd_Clt,Cd_Prv, IB_Anulado) 
values 
(@RucE,@Cd_Vou,@Ejer,@Prdo,@RegCtb,@Cd_Fte,@FecMov,@FecCbr,@NroCta,@Cd_TD,@NroSre,@NroDoc,@FecED,@FecVD,@Glosa,@MtoOr,@MtoD,@MtoH,@MtoD_ME,@MtoH_ME,@Cd_MdOr,@Cd_MdRg,
@CamMda,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Area,@Cd_MR,@Cd_TG,@IC_CtrMd,@IC_TipAfec,@TipOper,@NroChke,@Grdo,@IB_EsProv,getdate(),@UsuCrea,
@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc,@DR_NCND,@DR_NroDet,@DR_FecDet,@Cd_Clt,@Cd_Prv,0)
GO

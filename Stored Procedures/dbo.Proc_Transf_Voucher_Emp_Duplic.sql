SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_Transf_Voucher_Emp_Duplic]
@RucE nvarchar(11),
@Ejer varchar(4)
As
declare @Consulta varchar(4000)

set @Consulta='
declare @RucE nvarchar(11)
declare @Cd_Vou	int
declare @Ejer nvarchar(4)
declare @Prdo nvarchar(2)
declare @RegCtb nvarchar(15)
declare @Cd_Fte varchar(2)
declare @FecMov	smalldatetime
declare @FecCbr	smalldatetime
declare @NroCta nvarchar(10)
declare @Cd_Aux nvarchar(7)
declare @Cd_TD nvarchar(2)
declare @NroSre nvarchar(4)
declare @NroDoc nvarchar(15)
declare @FecED smalldatetime
declare @FecVD smalldatetime
declare @Glosa varchar(200)
declare @MtoOr numeric(13,2)
declare @MtoD numeric(13,2)
declare @MtoH numeric(13,2)
declare @MtoD_ME numeric(13,2)
declare @MtoH_ME numeric(13,2)
declare @Cd_MdOr nvarchar(2)
declare @Cd_MdRg nvarchar(2)
declare @CamMda	numeric(6,3)
declare @Cd_CC nvarchar(8)
declare @Cd_SC nvarchar(8)
declare @Cd_SS nvarchar(8)
declare @Cd_Area nvarchar(6)
declare @Cd_TG nvarchar(2)
declare @IC_CtrMd varchar(1)
declare @IC_TipAfec varchar(1)
declare @TipOper varchar(4)
declare @NroChke varchar(30)
declare @Grdo varchar(100)
declare @IB_Cndo bit
declare @IB_Conc bit
declare @IB_EsProv bit
declare @FecReg datetime
declare @FecMdf datetime
declare @UsuCrea nvarchar(10)
declare @UsuModf nvarchar(10)
declare @IB_Anulado bit
declare @DR_CdVou int
declare @DR_FecED smalldatetime
declare @DR_CdTD nvarchar(2)
declare @DR_NSre nvarchar(4)
declare @DR_NDoc nvarchar(15)
declare @IC_Gen varchar(1)
declare @FecConc smalldatetime
declare @IB_EsDes bit
declare @DR_NCND varchar(15)
declare @DR_NroDet varchar(15)
declare @DR_FecDet smalldatetime
declare @Cd_MR nvarchar(2)
declare @Cd_VouNew Int
'

declare @Consulta1 varchar(4000)
set @Consulta1='
declare _Cursorito Cursor For
SELECT 
	Cd_Vou, Ejer, Prdo, RegCtb, Cd_Fte, FecMov, FecCbr, NroCta, Cd_Aux, Cd_TD, NroSre, NroDoc, FecED, FecVD, Glosa,
	MtoOr, MtoD, MtoH, MtoD_ME, MtoH_ME, Cd_MdOr, Cd_MdRg, CamMda, Cd_CC, Cd_SC, Cd_SS, Cd_Area, Cd_TG, IC_CtrMd, IC_TipAfec,
	TipOper, NroChke, Grdo, IB_Cndo, IB_Conc, IB_ESProv, FecReg, FecMdf, UsuCrea, UsuModf, IB_Anulado, DR_CdVou, DR_FecED,
	DR_CdTD, DR_NSre, DR_NDoc, IC_Gen, FecConc, IB_EsDes, DR_NroDet, DR_FecDet, Cd_Mr
from 
	OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
	''SELECT 
		 RucE,Cd_Vou,Ejer,Prdo,RegCtb,Cd_Fte,FecMov,FecCbr,NroCta,Cd_Aux,Cd_TD,NroSre,NroDoc,FecED,FecVD,
		 Glosa,MtoOr,MtoD,MtoH,MtoD_ME,MtoH_ME,Cd_MdOr,Cd_MdRg,CamMda,Cd_CC,Cd_SC,Cd_SS,Cd_Area,Cd_TG,IC_CtrMd,IC_TipAfec,
		 TipOper,NroChke,Grdo,IB_Cndo,IB_Conc,IB_ESProv,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,DR_CdVou,DR_FecED,DR_CdTD,
		 DR_NSre,DR_NDoc,IC_Gen,FecConc,IB_EsDes,DR_NroDet,DR_FecDet,Cd_Mr
	  from 
		 dbo.Voucher where RucE='''''+@RucE+''''' and Ejer='''''+@Ejer+''''' '')

Open _Cursorito
Fetch Next From _Cursorito Into @Cd_Vou, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @MtoD_ME, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area, @Cd_TG, @IC_CtrMd, @IC_TipAfec, @TipOper, @NroChke, @Grdo, @IB_Cndo, @IB_Conc, @IB_ESProv, @FecReg, @FecMdf, @UsuCrea, @UsuModf, @IB_Anulado, @DR_CdVou, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @IC_Gen, @FecConc, @IB_EsDes, @DR_NroDet, @DR_FecDet, @Cd_Mr
While @@Fetch_Status = 0
Begin
	set @Cd_VouNew=dbo.Cod_Vou('''+@RucE+''')
	insert into voucher(RucE,Cd_Vou,Ejer,Prdo,RegCtb,Cd_Fte,FecMov,FecCbr,NroCta,Cd_Aux,Cd_TD,NroSre,NroDoc,FecED,FecVD,Glosa,MtoOr,MtoD,MtoH,MtoD_ME,MtoH_ME,Cd_MdOr,Cd_MdRg,CamMda,Cd_CC,Cd_SC,Cd_SS,Cd_Area,Cd_TG,IC_CtrMd,IC_TipAfec, TipOper,NroChke,Grdo,IB_Cndo,IB_Conc,IB_ESProv,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,DR_CdVou,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,IC_Gen,FecConc,IB_EsDes,DR_NroDet,DR_FecDet,Cd_MR,CA01)
	values ('''+@RucE+''',@Cd_VouNew,@Ejer,@Prdo,@RegCtb,@Cd_Fte,@FecMov,@FecCbr,@NroCta,@Cd_Aux,@Cd_TD,@NroSre,@NroDoc,@FecED,@FecVD,@Glosa,@MtoOr,@MtoD,@MtoH,@MtoD_ME,@MtoH_ME,@Cd_MdOr,@Cd_MdRg,@CamMda,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Area,@Cd_TG,@IC_CtrMd,@IC_TipAfec,@TipOper,@NroChke,@Grdo,@IB_Cndo,@IB_Conc,@IB_ESProv,@FecReg,@FecMdf,@UsuCrea,@UsuModf,@IB_Anulado,@DR_CdVou,@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc,@IC_Gen,@FecConc,@IB_EsDes,@DR_NroDet,@DR_FecDet,@Cd_MR,@Cd_Vou)
	Fetch Next From _Cursorito Into @Cd_Vou, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @MtoD_ME, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area, @Cd_TG, @IC_CtrMd, @IC_TipAfec, @TipOper, @NroChke, @Grdo, @IB_Cndo, @IB_Conc, @IB_ESProv, @FecReg, @FecMdf, @UsuCrea, @UsuModf, @IB_Anulado, @DR_CdVou, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @IC_Gen, @FecConc, @IB_EsDes, @DR_NroDet, @DR_FecDet, @Cd_Mr
End
Close _Cursorito
Deallocate _Cursorito
'
Print @Consulta+@Consulta1
exec (@Consulta+@Consulta1)

GO

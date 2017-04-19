SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Voucher]
@RucE nvarchar(11),
@Ejer varchar(4)
as

declare @Consulta varchar(4000)
set @Consulta='
insert into voucher(RucE,Cd_Vou,Ejer,Prdo,RegCtb,Cd_Fte,FecMov,FecCbr,NroCta,Cd_Aux,Cd_TD,NroSre,NroDoc,FecED,FecVD,Glosa,MtoOr,MtoD,MtoH,MtoD_ME,MtoH_ME,Cd_MdOr,Cd_MdRg,CamMda,Cd_CC,Cd_SC,Cd_SS,Cd_Area,Cd_TG,IC_CtrMd,IC_TipAfec, TipOper,NroChke,Grdo,IB_Cndo,IB_Conc,IB_ESProv,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,DR_CdVou,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,IC_Gen,FecConc,IB_EsDes,DR_NroDet,DR_FecDet,Cd_MR)
SELECT 
	RucE, /*dbo.Cod_Vou('''+@RucE+''')*/Cd_Vou, Ejer, Prdo, RegCtb, Cd_Fte, FecMov, FecCbr, NroCta, Cd_Aux, Cd_TD, NroSre, NroDoc, FecED, FecVD, Glosa,
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
		 dbo.Voucher where RucE='''''+@RucE+''''' and Ejer='''''+@Ejer+''''' '')'
print @Consulta
Exec(@Consulta)
--Exec [user321].[Proc_Transf_Voucher]  '11111111111' , '2011'
--select *from voucher where RucE='11111111111' and Ejer='2011' and Cd_Fte='RV'
GO

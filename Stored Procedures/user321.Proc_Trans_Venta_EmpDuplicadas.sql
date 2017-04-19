SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Proc_Trans_Venta_EmpDuplicadas]
@RucE nvarchar(11),
@Ejer varchar(4)
as


declare @Consulta varchar(4000)


set @Consulta='
declare @Cd_VtaAnt nvarchar(10)
declare @Cd_Vta nvarchar(10)
declare @Eje nvarchar(4)
declare @Prdo nvarchar(2)
declare @RegCtb nvarchar(15)
declare @FecMov smalldatetime
declare @Cd_FPC nvarchar(2)
declare @FecCbr smalldatetime
declare @Cd_TD nvarchar(2)
declare @NroSre varchar(5)
declare @NroDoc nvarchar(15)
declare @Cd_Sr_NO nvarchar(4)	     	     
declare @Cd_Num_NO nvarchar(7)
declare @FecED smalldatetime
declare @FecVD smalldatetime
declare @Cd_Cte_NO nvarchar(7)
declare @Cd_Vdr_NO nvarchar(7)
declare @Cd_Area nvarchar(6)
declare @Cd_MR nvarchar(2)
declare @Obs varchar(1000)
declare @Valor numeric(13,2)
declare @TotDsctoP	numeric(5,2)
declare @TotDsctoI numeric(13,2)
declare @ValorNeto numeric(13,2)
declare @BaseSinDsctoF numeric(13,2)
declare @DsctoFnzP numeric(5,2)
declare @DsctoFnzI numeric(13,2)
declare @Cd_IAV_DF char(1)
declare @INF_Neto numeric(13,2)
declare @EXO_Neto numeric(13,2)
declare @EXPO_Neto numeric(13,2)
declare @BIM_Neto numeric(13,2)
declare @IGV numeric(13,2)
declare @Total numeric(13,2)
declare @Percep numeric(13,2)
declare @Cd_Mda nvarchar(2)	     	     
declare @CamMda numeric(6,3)
declare @FecReg datetime
declare @FecMdf datetime
declare @UsuCrea nvarchar(10)
declare @UsuModf nvarchar(10)
declare @IB_Anulado bit
declare @IB_Cbdo bit
declare @DR_CdVta nvarchar(10)
declare @DR_FecED smalldatetime
declare @DR_CdTD	nvarchar(2)	     	     
declare @DR_NSre nvarchar(4)
declare @DR_NDoc nvarchar(15)
declare @CA01 varchar(100)
declare @CA02 varchar(100)
declare @CA03 varchar(100)
declare @CA04 varchar(100)
declare @CA05 varchar(100)
declare @CA06 varchar(100)
declare @CA07 varchar(100)
declare @CA08 varchar(100)
declare @CA09 varchar(100)
declare @CA10 varchar(100)
declare @CA11 varchar(100)
declare @CA12 varchar(100)
declare @CA13 varchar(100)
declare @CA14 varchar(100)
declare @CA15 varchar(100)
declare @Cd_OP char(10)
declare @NroOP varchar(20)
declare @Cd_CC nvarchar(8)
declare @Cd_SC nvarchar(8)	     	     
declare @Cd_SS nvarchar(8)
declare @Cd_MIS char(3)	     	     
declare @Cd_Clt char(10)
declare @Cd_Vdr char(7)
declare @CostoTot numeric(13,2)


declare _Cursorito Cursor For'
declare @Consulta1 varchar(max)

set @Consulta1='
	SELECT 
		Cd_Vta, Prdo, RegCtb, FecMov, Cd_FPC, FecCbr, Cd_TD, NroSre, NroDoc,
		FecED, FecVD, Cd_Cte, Cd_Vdr, Cd_Area, Cd_MR, Obs, Valor, TotDsctoP, TotDsctoI,
		ValorNeto, BaseSinDsctoF, DsctoFnzP, DsctoFnzI, INF_Neto, EXO_Neto, EXPO_Neto, 
		BIM_Neto, IGV, Total, Cd_Mda, CamMda, FecReg, FecMdf, UsuCrea, UsuModf,
		IB_Anulado, IB_Cbdo, DR_CdVta, DR_FecED, DR_CdTD, DR_NSre, DR_NDoc,
		CA01, CA02, CA03, CA04, CA05, CA06, CA07, CA08, CA09, CA10, CA11, CA12, 
		CA13, CA14, CA15, Cd_OP, NroOP, Cd_CC, Cd_SC, Cd_SS,''001'' As Cd_MIS
	from 
		OPENROWSET(''SQLOLEDB'', ''netserver'';''Usu123_1'';''user123'',
        	''SELECT 
			ve.RucE,ve.Cd_Vta,ve.Eje,ve.Prdo,ve.RegCtb, ve.FecMov,ve.Cd_FPC,ve.FecCbr,ve.Cd_TD, se.NroSerie NroSre, ve.NroDoc, Isnull(ve.FecED,ve.FecMov) As FecED, isnull(ve.FecVD,ve.FecMov) As FecVD,
			ve.Cd_Cte, ve.Cd_Vdr,ve.Cd_Area, ve.Cd_MR,ve.Obs, 0.00 Valor, ve.TotDsctoP, ve.TotDsctoI,ve.ValorNeto, 0.00 BaseSinDsctoF, ve.DsctoFnzP, ve.DsctoFnzI,
			0.00 INF_Neto, 0.00 EXO_Neto, 0.00 EXPO_Neto, BIM as BIM_Neto,ve.IGV, ve.Total,ve.Cd_Mda, ve.CamMda,ve.FecReg, ve.FecMdf,ve.UsuCrea, ve.UsuModf,
			ve.IB_Anulado, ve.IB_Cbdo,ve.DR_CdVta, ve.DR_FecED, ve.DR_CdTD, ve.DR_NSre, ve.DR_NDoc,ve.CA01, ve.CA02, ve.CA03, ve.CA04, ve.CA05,
			ve.CA06, ve.CA07, ve.CA08, ve.CA09, ve.CA10,ve.CA11, ve.CA12, ve.CA13, ve.CA14, ve.CA15,ve.Cd_OP, ve.NroOP,ve.Cd_CC, ve.Cd_SC, ve.Cd_SS
		FROM 
			dbo.Venta ve left join dbo.Serie se on
			se.RucE=ve.RucE and se.Cd_Sr=ve.Cd_Sr and se.Cd_TD=ve.Cd_TD
	 	where 
			ve.RucE='''''+@RucE+''''' and ve.Eje='''''+@Ejer+'''''
	 	order by 
			ve.Cd_Vta'') 

Open _Cursorito
	Fetch Next From _Cursorito 
	Into @Cd_VtaAnt, @Prdo, @RegCtb, @FecMov, @Cd_FPC, @FecCbr, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Cd_Cte_NO, @Cd_Vdr_NO, @Cd_Area, @Cd_MR, @Obs, @Valor, @TotDsctoP, @TotDsctoI, @ValorNeto, @BaseSinDsctoF, @DsctoFnzP, @DsctoFnzI, @INF_Neto, @EXO_Neto, @EXPO_Neto, @BIM_Neto, @IGV, @Total, @Cd_Mda, @CamMda, @FecReg, @FecMdf, @UsuCrea, @UsuModf, @IB_Anulado, @IB_Cbdo, @DR_CdVta, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10, @CA11, @CA12, @CA13, @CA14, @CA15, @Cd_OP, @NroOP, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_MIS
	While @@Fetch_Status = 0
	Begin
	
		set @Cd_Vta=user123.Cod_Vta('''+@RucE+''')
		insert into Venta(RucE,Cd_Vta,Eje,Prdo,RegCtb,FecMov,Cd_FPC,FecCbr,Cd_TD,NroSre,NroDoc,FecED,FecVD,Cd_Cte_NO,Cd_Vdr_NO,Cd_Area,Cd_MR,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,BaseSinDsctoF,DsctoFnz_P,DsctoFnz_I,INF_Neto,EXO_Neto,EXPO_Neto,BIM_Neto,IGV,Total,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,IB_Cbdo,DR_CdVta,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,Cd_OP,NroOP,Cd_CC,Cd_SC,Cd_SS,Cd_MIS)
			values('''+@RucE+''',@Cd_Vta,'''+@Ejer+''',@Prdo,@RegCtb,@FecMov,@Cd_FPC,@FecCbr,@Cd_TD,@NroSre,@NroDoc,@FecED,@FecVD,@Cd_Cte_NO,@Cd_Vdr_NO,@Cd_Area,@Cd_MR,@Obs,@Valor,@TotDsctoP,@TotDsctoI,@ValorNeto,@BaseSinDsctoF,@DsctoFnzP,@DsctoFnzI,@INF_Neto,@EXO_Neto,@EXPO_Neto,@BIM_Neto,@IGV,@Total,@Cd_Mda,@CamMda,@FecReg,@FecMdf,@UsuCrea,@UsuModf,@IB_Anulado,@IB_Cbdo,@DR_CdVta,@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15,@Cd_OP,@NroOP,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_MIS)
'
declare @Consulta2 varchar(max)
set @Consulta2='
		exec user321.Proc_Transf_VentaDetDuplicados '''+@RucE+''',@Cd_VtaAnt,@Cd_Vta,'''+@Ejer+'''

		
		Fetch Next From _Cursorito Into @Cd_VtaAnt, @Prdo, @RegCtb, @FecMov, @Cd_FPC, @FecCbr, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Cd_Cte_NO, @Cd_Vdr_NO, @Cd_Area, @Cd_MR, @Obs, @Valor, @TotDsctoP, @TotDsctoI, @ValorNeto, @BaseSinDsctoF, @DsctoFnzP, @DsctoFnzI, @INF_Neto, @EXO_Neto, @EXPO_Neto, @BIM_Neto, @IGV, @Total, @Cd_Mda, @CamMda, @FecReg, @FecMdf, @UsuCrea, @UsuModf, @IB_Anulado, @IB_Cbdo, @DR_CdVta, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @CA01, @CA02, @CA03, @CA04, @CA05, @CA06, @CA07, @CA08, @CA09, @CA10, @CA11, @CA12, @CA13, @CA14, @CA15, @Cd_OP, @NroOP, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_MIS
	End
Close _Cursorito
Deallocate _Cursorito
'
print @Consulta+@Consulta1+@Consulta2
Exec(@Consulta+@Consulta1+@Consulta2)


--exec user321.Proc_Trans_VentaCab '20492317251','2011'
GO

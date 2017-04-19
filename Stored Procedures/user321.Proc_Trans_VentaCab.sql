SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Proc_Trans_VentaCab]
@RucE nvarchar(11),
@Ejer varchar(4)
as
declare @Consulta varchar(4000)

set @Consulta='
	insert into Venta(RucE,Cd_Vta,Eje,Prdo,RegCtb,FecMov,Cd_FPC,FecCbr,Cd_TD,NroSre,NroDoc,FecED,FecVD,Cd_Cte_NO,Cd_Vdr_NO,Cd_Area,Cd_MR,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,BaseSinDsctoF,DsctoFnz_P,DsctoFnz_I,INF_Neto,EXO_Neto,EXPO_Neto,BIM_Neto,IGV,Total,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado,IB_Cbdo,DR_CdVta,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,Cd_OP,NroOP,Cd_CC,Cd_SC,Cd_SS,Cd_MIS)
	SELECT 
		RucE, Cd_Vta, Eje, Prdo, RegCtb, FecMov, Cd_FPC, FecCbr, Cd_TD, NroSre, NroDoc,
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
			ve.Cd_Vta'') '
print @Consulta
Exec(@Consulta)


--exec user321.Proc_Trans_VentaCab '20492317251','2011'
GO

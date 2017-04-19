SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ConsultarVenta_x_Srv_CASAMARILLA]

@RucE nvarchar(11),
@Dato varchar(8000),
@msj varchar(100) output

AS

DECLARE @SQL varchar(8000)
SET @SQL =
		'
		Select DISTINCT v.*,d.Cd_Srv,d.Total As TotalServ,
				Case When upper(s.Nombre) like ''MENSUA%'' or upper(s.Nombre) like ''%MORA%'' Then Case When isnull(d.CA01,'''')='''' Then v.Prdo Else d.CA01 End Else '''' End As Periodo,
				--Case When upper(s.Nombre) like ''MENSUA%'' Then Case When len(case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End)<=2 Then case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End Else v.Prdo End Else Case When upper(s.Nombre) like ''MATRICULA%'' or upper(s.Nombre) like ''UNIFORME%'' Then right(''00''+MONTH(v.FecVD),2) Else v.Prdo End End AS Periodo,
				isnull(t.RSocial,isnull(t.ApPat,'''')+'' ''+isnull(t.ApMat,'''')+'' ''+isnull(t.Nom,'''')) As NomCli,				
				isnull(o.Cd_Vou,0) As Cd_Vou,
				isnull(o.RegCtb,'''') As RegCtbVou,
				isnull(o.Prdo,'''') As PrdoVou,
				isnull(o.Cd_Fte,'''') As Cd_FteVou,
				isnull(Convert(varchar,o.FecMov,103),'''') As FecMovVou,
				isnull(o.NroCta,'''') As NroCtaVou,
				isnull(o.Cd_Clt,'''') As Cd_CltVou,
				isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) As NomAux,
				isnull(o.Cd_TD,'''') As Cd_TDVou,
				isnull(o.NroSre,'''') As NroSreVou,
				isnull(o.NroDoc,'''') As NroDocVou,
				isnull(Convert(varchar,o.FecED,103),'''') As FecEDVou,
				isnull(Convert(varchar,o.FecVD,103),'''') As FecVDVou,
				isnull(o.Glosa,'''') As GlosaVou,
				isnull(o.MtoD,0.00) As MtoDVou,
				isnull(o.MtoH,0.00) As MtoHVou,
				isnull(o.MtoD_ME,0.00) As MtoD_MEVou,
				isnull(o.MtoH_ME,0.00) As MtoH_MEVou,
				isnull(o.Cd_MdOr,'''') As Cd_MdOrVou,
				isnull(o.Cd_MdRg,'''') As Cd_MdRgVou,
				isnull(o.CamMda,0.000) As CamMdaVou,
				isnull(o.Cd_CC,'''') As Cd_CCVou,
				isnull(o.Cd_SC,'''') As Cd_SCVou,
				isnull(o.Cd_SS,'''') As Cd_SSVou,
				isnull(o.Cd_Area,'''') As Cd_AreaVou,
				isnull(o.Cd_MR,'''') As Cd_MRVou,
				isnull(o.Cd_TG,'''') As Cd_TGVou,
				isnull(o.IC_CtrMd,'''') As IC_CtrMdVou,
				isnull(o.IC_TipAfec,'''') As IC_TipAfecVou,
				isnull(o.TipOper,'''') As TipOperVou,
				isnull(o.NroChke,'''') As NroChkeVou,
				isnull(o.Grdo,'''') As GrdoVou,
				isnull(o.UsuCrea,'''') As UsuCreaVou,
				isnull(o.DR_CdTD,'''') AS DR_CdTDVou,
				isnull(o.DR_NSre,'''') AS DR_NSreVou,
				isnull(o.DR_NDoc,'''') AS DR_NDocVou,
				isnull(x.NCorto,'''') AS NomTDVou
				,isnull(res.IB_Saldado,0) As Saldado
		From Venta v 
			left Join Cliente2 t On t.RucE=v.RucE and t.Cd_Clt=v.Cd_Clt
			left join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
			left join Voucher o On o.RucE=v.RucE and o.Ejer=v.Eje and o.RegCtb=v.RegCtb and o.Cd_Clt=v.Cd_Clt and o.Cd_TD=v.Cd_TD and o.NroSre=v.NroSre and o.NroDoc=v.NroDoc
			left Join Cliente2 c On c.RucE=o.RucE and c.Cd_Clt=o.Cd_Clt
			left Join Servicio2 s On s.RucE=d.RucE and s.Cd_Srv=d.Cd_Srv
			Left Join TipDoc x On x.Cd_TD=o.Cd_TD
			left Join (	
						Select RucE,Cd_Clt,Cd_TD,NroSre,NroDoc As NroDoc,Sum(MtoD-MtoH) As SaldoS,Sum(MtoD_ME-MtoH_ME) As SaldoD,Convert(bit,1) As IB_Saldado
						From Voucher Where RucE='''+@RucE+''' and isnull(IB_Anulado,0)=0 and isnull(Cd_Clt,'''')<>'''' and isnull(NroDoc,'''')<>'''' and isnull(Cd_TD,'''') in (''01'',''03'',''07'',''08'')
						group by RucE,Cd_Clt,Cd_TD,NroSre,NroDoc
						having Sum(MtoD-MtoH)+Sum(MtoD_ME-MtoH_ME)=0
					   ) res On res.RucE=v.RucE and res.Cd_Clt=v.Cd_Clt and res.Cd_TD=v.Cd_TD and res.NroSre=v.NroSre and res.NroDoc=v.NroDoc
					   
		Where 
			v.RucE='''+@RucE+'''
		'
PRINT @SQL
--PRINT ' and (v.Eje+''_''+v.Cd_Clt+''_''+d.Cd_Srv+''_''+d.CA01 in ('+@Dato+') or v.Eje+''_''+v.Cd_Clt+''_''+d.Cd_Srv+''_''+v.Prdo in ('+@Dato+'))'
PRINT ' and (v.Eje+''_''+v.Cd_Clt+''_''+v.CA01+''_''+d.Cd_Srv+''_''+Case When upper(s.Nombre) like ''MENSUA%'' /*or upper(s.Nombre) like ''%MORA%''*/ Then Case When len(case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End)<=2 Then case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End Else v.Prdo End Else Case When right(''00''+ltrim(MONTH(v.FecVD)),2)<>v.Prdo /*upper(s.Nombre) like ''MATRICULA%'' or upper(s.Nombre) like ''UNIFORME%''*/ Then right(''00''+ltrim(MONTH(v.FecVD)),2) Else v.Prdo End End in ('+@Dato+'))'


EXEC(@SQL+' and (v.Eje+''_''+v.Cd_Clt+''_''+v.CA01+''_''+d.Cd_Srv+''_''+Case When upper(s.Nombre) like ''MENSUA%'' /*or upper(s.Nombre) like ''%MORA%''*/ Then Case When len(case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End)<=2 Then case when isnull(d.CA01,'''')<>'''' Then d.CA01 Else Case when isnull(d.Obs,'''')<>'''' Then d.Obs Else v.Prdo End End Else v.Prdo End Else Case When right(''00''+ltrim(MONTH(v.FecVD)),2)<>v.Prdo /*upper(s.Nombre) like ''MATRICULA%'' or upper(s.Nombre) like ''UNIFORME%''*/ Then right(''00''+ltrim(MONTH(v.FecVD)),2) Else v.Prdo End End in ('+@Dato+'))')
--EXEC (@SQL+' and (v.Eje+''_''+v.Cd_Clt+''_''+d.Cd_Srv+''_''+d.CA01 in ('+@Dato+') or
--			      v.Eje+''_''+v.Cd_Clt+''_''+d.Cd_Srv+''_''+v.Prdo in ('+@Dato+'))')



-- Leyenda --
-- DI : 08/11/2012 <Creacion del SP>
GO

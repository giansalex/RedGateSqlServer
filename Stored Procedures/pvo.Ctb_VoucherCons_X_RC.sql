SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [pvo].[Ctb_VoucherCons_X_RC]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
--@Ejer	 nvarchar(4),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@msj varchar(100) output
as
if exists (select top 1 * from Voucher where RucE = @RucE and RegCtb=@RegCtb) --and exists (select * from CampoV where RucE=@RucE)
begin
select 
	--vou.RucE, vou.Cd_Vou, vou.Ejer, vou.Prdo, 
	vou.RegCtb, 
	--vou.Cd_Fte, 
	convert(varchar(10),vou.FecMov,103) as FecMov,
	convert(varchar(10),vou.FecCbr,103) as FecCbr,
	vou.NroCta,
	vou.Cd_TD, td.Descrip as DescripTD, td.NCorto as NCortoTD,
	vou.NroSre, vou.NroDoc, 
	convert(varchar(10),vou.FecED,103) as FecED,
	convert(varchar(10),vou.FecVD,103) as FecVD,
	vou.Glosa, /*vou.MtoOr,*/ vou.MtoD, vou.MtoH,
	--vou.Cd_MdOr, moor.Simbolo as SimMdOr,
	vou.Cd_MdRg, morg.Simbolo as SimMdRg,
	vou.CamMda, 
	vou.MtoD_ME, vou.MtoH_ME,
	vou.IC_CtrMd,
	vou.Cd_CC, vou.Cd_SC, vou.Cd_SS, 
	vou.Cd_Area, ar.NCorto as NCortoArea,
	vou.Cd_MR, md.Nombre as NomMR,
	vou.NroChke, 
	vou.Cd_TG, tg.nombre as NomTGasto,
	vou.FecReg, --vou.FecMdf,
	vou.UsuCrea, --vou.UsuModf, vou.IB_Anulado,
	
	vou.Cd_Aux,case(isnull(len(au.RSocial),0))
		         	     when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom
			 	     else au.RSocial end as NomComCte


from Voucher vou
	left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	where vou.RucE=@RucE and RegCtb=@RegCtb  order by Cd_Vou
--	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou

end
else print 'no hay'
print @msj

------CODIGO DE MODIFICACION--------
--CM=MG01

--exec pvo.Ctb_VoucherConsUn_X_RC '111111111111','2009','CTGN_RC05-00001',null

--PV: MIE 11/02/09
--PV: JUE 14/05/09 --> Mdf: agrgue campos Mto_ME
--PV: MIE 10/06/09 --> Mdf: agrgue consulta x prdo
GO

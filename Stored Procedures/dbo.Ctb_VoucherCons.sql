SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@msj varchar(100) output
as
if exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Eje) --and exists (select * from CampoV where RucE=@RucE) --> ESTO NO VAAAA
begin
	print 'entro'
select 

	vou.RucE, 
	vou.Cd_Vou, 
	vou.RegCtb, 
	vou.Cd_Fte, 
	vou.NroCta,
	vou.MtoD, 
	vou.MtoH,
	vou.MtoD_ME,
	vou.MtoH_ME,
	vou.Cd_MdRg,
	morg.Simbolo as SimMdRg,
	vou.IC_TipAfec,
	vou.Ejer, 
	vou.Prdo, 
	convert(varchar(10),vou.FecMov,103) as FecMov,
	vou.Glosa, 
	convert(varchar(10),vou.FecCbr,103) as FecCbr,	
	au.Cd_TDI,au.NDoc,vou.Cd_Aux,case(isnull(len(au.RSocial),0))
		         	     when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom
			 	     else au.RSocial end as NomComCte,
	vou.Cd_TD, 
	td.Descrip as DescripTD, 
	td.NCorto as NCortoTD,
	vou.NroSre, 
	vou.NroDoc, 
	convert(varchar(10),vou.FecED,103) as FecED,
	convert(varchar(10),vou.FecVD,103) as FecVD,
	vou.MtoOr, 
	vou.Cd_MdOr,
	moor.Simbolo as SimMdOr,  
	vou.CamMda, 
	vou.Cd_CC, 
	vou.Cd_SC, 
	vou.Cd_SS, 
	vou.Cd_Area, 
	ar.NCorto as NCortoArea,
	vou.Cd_MR, 
	md.Nombre as NomMR,
	vou.NroChke, 
	vou.Cd_TG, 
	tg.nombre as NomTGasto,
	--vou.FecReg,
	 vou.FecMdf,
	vou.UsuCrea, 
	vou.UsuModf, 
	left(convert(varchar, vou.FecReg,103), 10) as FechaReg, convert(varchar,vou.FecReg,108) as HoraReg,
	vou.IB_Anulado
	--vou.Cd_CC, --cc.NCorto as NCCostos,
	--vou.Cd_SC, --cs.NCorto as NCCSub,
	--vou.Cd_SS, --ss.NCorto as NCCSubSub,
	

from Voucher vou
	left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	--left join CCostos cc on  vou.Cd_CC= cc.Cd_CC
	--left join CCSub cs on  vou.Cd_SC= cs.Cd_SC
	--left join CCSubSub ss on  vou.Cd_SS= ss.Cd_SS
	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou
end
print @msj

------CODIGO DE MODIFICACION--------
--CM=MG01

--PV: MIE 11/02/09  --> Error J --> if exists (select top 1 * from Venta where RucE = @RucE and Eje=@Eje) and exists (select * from CampoV where RucE=@RucE)
--JR: MIE 18/03/09 
--JR: JUE 19/03/09  -- agregue la fecha y hora de registro
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherCons_X_RC3]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@Ejer	 nvarchar(4),
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
	
	--vou.Cd_Aux,
	case(isnull(len(vou.Cd_Clt),0)) when 0 then vou.Cd_Prv else vou.Cd_Clt end  as Cd_Aux,
	
	case(isnull(len(vou.Cd_Clt),0)) when 0 then 
						    case(isnull(len(vou.Cd_Prv),0)) when 0 then null
											   else case(isnull(len(p.RSocial),0)) when 0 then isnull(nullif(p.ApPat +' '+p.ApMat+' '+p.Nom,''),'------- SIN NOMBRE ------') else p.RSocial  end  
						    end
					       else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 

	end 
	as NomComCte,
	vou.CA01,
	vou.CA02,
	vou.CA03,
	vou.CA04,
	vou.CA05,
	vou.CA06,
	vou.CA07,
	vou.CA08,
	vou.CA09,
	vou.CA10,
	vou.CA11,
	vou.CA12,
	vou.CA13,
	vou.CA14,
	vou.CA15
	--case(isnull(len(au.RSocial),0))
	--when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom else au.RSocial end as NomComCte


from Voucher vou
	--left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join proveedor2 p on p.RucE=vou.RucE and p.Cd_Prv=vou.Cd_Prv
	left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt=c.Cd_Clt
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	where vou.RucE=@RucE and RegCtb=@RegCtb and Ejer=@Ejer order by Cd_Vou
--	where vou.RucE=@RucE and vou.Ejer=@Eje and vou.Prdo between @PrdoIni and @PrdoFin order by Cd_Vou

end
else print 'no hay'
print @msj

--exec pvo.Ctb_VoucherConsUn_X_RC '111111111111','2009','CTGN_RC05-00001',null

--exec pvo.Ctb_VoucherCons_X_RC2 '11111111111','CTGE_RV10-00003','2010',null
--select * from voucher where RucE='11111111111' and RegCtb='CTGE_RV10-00003'


--PV: MIE 11/02/09
--PV: JUE 14/05/09 --> Mdf: agrgue campos Mto_ME
--PV: MIE 10/06/09 --> Mdf: agrgue consulta x prdo
--JJ: VIE 17/09/10 --> Mdf: se elimino las relaciones con Auxiliar
--PV: JUE 28/10/10 --> Mdf: se agrego para que salga Cd_Clt / Cd_Prv  -- Linea: case(isnull(vou.Cd_Clt,0)) when 0 then vou.Cd_Prv else vou.Cd_Clt end  as Cd_Aux,
--PV: JUE 02/11/10 --> Mdf: se modifico para que no "------- SIN NOMBRE ------" cuando cod Clt/Prv
--MP: LUN 11/03/13 --> Mdf: se recreo para poder agreagar los campos adicionales
GO

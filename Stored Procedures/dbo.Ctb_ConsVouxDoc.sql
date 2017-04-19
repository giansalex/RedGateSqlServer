SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Ctb_ConsVouxDoc '11111111111','2012',null,'PRV0494','01',null,'789789'
CREATE procedure [dbo].[Ctb_ConsVouxDoc]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Clt	char(10),
@Cd_Prv	char(7),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15)
as
--set @RucE='11111111111'
--set @Ejer='2012'
--set @Cd_Prv='PRV0494'
--set @Cd_Clt=''
--set @Cd_TD='01'
--set @NroSre=''
--set @NroDoc='789789'

select 
		vou.RucE, vou.Cd_Vou, vou.RegCtb, vou.Cd_Fte, vou.NroCta, pcta.NomCta,
		Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD end as MtoD, Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH end as MtoH,
		Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD_ME end as MtoD_ME, Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH_ME end as MtoH_ME, 
		vou.Cd_MdRg, morg.Simbolo as SimMdRg, vou.CamMda, vou.IC_CtrMd, case(IC_CtrMd) when 'a' then 'Ambos' else 
		(case(IC_CtrMd) when 's' then 'Soles' else (case(IC_CtrMd) when '$' then 'Dolares' else '' end) end) end as CtrMdaDetalle, 
		vou.IC_TipAfec, case vou.IB_EsProv when 1 then convert(bit,1) else convert(bit,0) end as IB_EsProv,
		vou.Ejer, vou.Prdo, convert(varchar,vou.FecMov,103) as FecMov, 
		vou.Glosa, 	convert(varchar(10),vou.FecCbr,103) as FecCbr, case(isnull(len(vou.Cd_Clt),0)) when 0 then tdip.NCorto else tdic.NCorto end as NCorto, 
		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end as Cd_TDI,
    	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NDoc,
		isnull(vou.Cd_Clt,vou.Cd_Prv) as Cd_Aux, 
		case(isnull(len(vou.Cd_Clt),0)) when 0 then 
			case(isnull(len(vou.Cd_Prv),0)) when 0 then null else case(isnull(len(p.RSocial),0)) when 0 then isnull(nullif(p.ApPat +' '+p.ApMat+' '+p.Nom,''),'------- SIN NOMBRE ------') else p.RSocial  end  
			end else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end as NomComCte,
		vou.Cd_TD, td.Descrip as DescripTD, td.NCorto as NCortoTD, 
		vou.NroSre, vou.NroDoc, vou.NroChke, 
		vou.Grdo, case vou.IB_Conc when 1 then convert(bit,1) else convert(bit,0) end as IB_Conc, 
		convert(varchar,vou.FecED,103) as FecED, convert(varchar,vou.FecVD,103) as FecVD, 
		cc.Cd_CC + ' - ' + cc.Descrip as Cd_CC, s.Cd_SC + ' - ' + s.Descrip as Cd_SC,
		ss.Cd_SS + ' - ' + ss.Descrip as Cd_SS, vou.Cd_Area, ar.NCorto as NCortoArea, 
		vou.Cd_MR, md.Nombre as NomMR, convert(varchar, vou.FecReg,103) as FecReg, 
		convert(varchar, vou.FecMdf,103) as FecMdf, vou.UsuCrea, vou.UsuModf, 
		convert(varchar,vou.FecReg,108) as HoraReg, case vou.IB_Anulado when 1 then convert(bit,1) else convert(bit,0) end as IB_Anulado,
		vou.DR_NSre, vou.DR_NDoc, vou.DR_NroDet, vou.DR_FecDet
from 
	voucher vou
	left join proveedor2 p on p.RucE=vou.RucE and p.Cd_Prv=vou.Cd_Prv
	left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt=c.Cd_Clt
	left join TipDocIdn tdic on tdic.Cd_TDI=c.Cd_TDI 
	left join TipDocIdn tdip on tdip.Cd_TDI=p.Cd_TDI
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	left join PlanCtas pcta on vou.RucE=pcta.RucE and vou.NroCta=pcta.NroCta and pcta.Ejer=vou.Ejer
	left join CCostos cc on cc.RucE = vou.RucE and cc.Cd_CC = vou.Cd_CC
	left join CCSub s on cc.RucE = s.RucE and cc.Cd_CC = s.Cd_CC and s.Cd_SC = vou.Cd_SC
	left join CCSubSub ss on cc.RucE = ss.RucE and cc.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = vou.Cd_SS
where 
	vou.RucE=@RucE and vou.Ejer=@Ejer  
	and vou.RegCtb in(
		select RegCtb from voucher v
		where v.RucE=@RucE and v.Ejer=@Ejer
			and Case When isnull(@Cd_Clt,'')<>'' Then v.Cd_Clt Else '' End =isnull(@Cd_Clt,'')
			and Case When isnull(@Cd_Prv,'')<>'' Then v.Cd_Prv Else '' End =isnull(@Cd_Prv,'')
			and v.Cd_TD=@Cd_TD
			and Case When isnull(@NroSre,'')<>'' Then v.NroSre Else '' End =isnull(@NroSre,'')
			and v.NroDoc=@NroDoc
	)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImpCompCons_4] 
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output

as
	--declare @ejer char(4)
	--set @ejer = '2012'--(select top 1 v.ejer from impcomp ip inner join voucher v on v.ruce=ip.ruce and v.regctb=ip.regctb where ip.Cd_IP=@Cd_IP and ip.ruce=@RucE)
		 		  
	select i.RucE,i.Cd_IP,i.ItemIC,i.RegCtb, i.NroCta,pc.NomCta, i.Cd_Mda,i.CamMda,
	v2.Cd_TD As Cd_TD,
	v2.NroSre As NroSre,
	v2.NroDoc As NroDoc,
	v2.Ejer,
	sum(v.MtoD-v.MtoH)  as Imp,
	sum (v.MtoD_ME-v.MtoH_ME) as Imp_Me,
	i.CstAsig,i.CstAsig_ME,i.PorcAsig,i.Cd_TipDist,i.TipGasto,i.TipInconterms,
	case when i.Cd_Mda ='01' then 'S/.' else 'US$' end as Moneda
	from ImpComp as i
	left join voucher v on v.RucE=i.RucE and v.ejer = i.Ejer and v.RegCtb=i.RegCtb and  v.CamMda=i.CamMda and v.NroCta = i.NroCta
	left join (select RucE, Ejer, RegCtb, max(Cd_TD) as Cd_TD, max(NroSre) as NroSre, max(NroDoc) as NroDoc from Voucher where RucE = @RucE group by RucE, Ejer, RegCtb) as v2 on v2.RucE=i.RucE and v2.RegCtb=i.RegCtb and v2.Ejer = i.Ejer  --and isnull(v2.IB_esProv,0)=1
	left join planctas pc on pc.NroCta = v.NroCta and pc.RucE=v.RucE and pc.Ejer = v.Ejer
	where i.RucE=@RucE and Cd_IP=@Cd_IP
		  --and v2.Cd_TD is not null and v2.NroSre is not null and v2.NroDoc is not null
	group by i.RucE,i.Cd_IP,i.ItemIC,i.Cd_Mda,i.CamMda,v.Cd_MdOr, i.CstAsig, i.CstAsig_ME, v2.Ejer,
			 i.PorcAsig,i.Cd_TipDist,i.TipGasto,i.TipInconterms, v.Cd_MdOr,i.RegCtb, i.NroCta,v.CamMda,pc.NomCta, v2.Cd_TD, v2.NroSre, v2.NroDoc
	order by i.RegCtb
GO

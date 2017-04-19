SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Imp_ImpCompCons_3] 
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as
	select i.RucE,i.Cd_IP,i.ItemIC, i.RegCtb, i.NroCta,i.Cd_Mda,i.CamMda,
	case (v.Cd_MdOr) when '01' then sum(v.MtoD-v.MtoH) else sum(v.MtoD_ME-v.MtoH_ME)*v.CamMda end as Imp,
	case (v.Cd_MdOr) when '01' then sum(v.MtoD-v.MtoH) / v.CamMda else sum (v.MtoD_ME-v.MtoH_ME) end as Imp_Me,
	i.CstAsig,i.CstAsig_ME,i.PorcAsig,i.Cd_TipDist,i.TipGasto,i.TipInconterms
	from ImpComp as i
	inner join voucher v on v.RucE=i.RucE and v.RegCtb=i.RegCtb and v.NroCta = i.NroCta and v.CamMda=i.CamMda
	where i.RucE=@RucE and Cd_IP=@Cd_IP
	group by i.RucE,i.Cd_IP,i.ItemIC,i.Cd_Mda,i.CamMda,v.Cd_MdOr, i.CstAsig, i.CstAsig_ME,
			 i.PorcAsig,i.Cd_TipDist,i.TipGasto,i.TipInconterms, v.Cd_MdOr,i.RegCtb, i.NroCta,v.CamMda
	


--exec Imp_ImpCompCons_2 '20545551641','IP00001',null
--exec Imp_ImpCompCons_2 '11111111111','IP00045',null

GO

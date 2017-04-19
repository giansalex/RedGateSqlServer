SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImpCompCons] 
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as
	select i.RucE,i.Cd_IP,i.ItemIC, i.Cd_Com,i.Cd_Mda,i.CamMda,
	case(i.Cd_Mda) when '01' then isnull(c.BIM_S,0)+isnull(c.BIM_E,0)+isnull(c.BIM_C,0)+isnull(c.Imp_N,0)+isnull(c.Imp_O,0) else (isnull(c.BIM_S,0)+isnull(c.BIM_E,0)+isnull(c.BIM_C,0)+isnull(c.Imp_N,0)+isnull(c.Imp_O,0))/i.CamMda end as 'Imp',
	case(i.Cd_Mda) when '01' then (isnull(c.BIM_S,0)+isnull(c.BIM_E,0)+isnull(c.BIM_C,0)+isnull(c.Imp_N,0)+isnull(c.Imp_O,0))*i.CamMda else isnull(c.BIM_S,0)+isnull(c.BIM_E,0)+isnull(c.BIM_C,0)+isnull(c.Imp_N,0)+isnull(c.Imp_O,0) end as 'Imp_ME',
	i.CstAsig,i.CstAsig_ME,i.PorcAsig,i.Cd_TipDist,i.TipGasto,i.TipInconterms from ImpComp as i
	inner join Compra as c on c.RucE = i.RucE and c.Cd_Com = i.Cd_Com
	where i.RucE=@RucE and Cd_IP=@Cd_IP
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioSC]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from(
	select sc.cd_SCo as 'DOC',
	case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, sc.cd_sco, 1, ib_autcomniv, 2)) when 1 then 'NO' else 'SI' end) 
	else ( case (dbo.verificarAutNvl(@RucE, sc.cd_sco, niv, ib_autcomniv, 2)) when 1 then 'NO' 
	else (case (dbo.verificarAutNvl(@RucE, sc.cd_sco, niv-1, ib_autcomniv, 2)) when 1 then 'SI' else 'NO' end) end) end
	as 'Autoriza'
	from solicitudCom sc 
	join CfgAutorizacion ca on sc.RucE = ca.RucE and ca.Cd_DMA = 'SC' and ca.Tipo = sc.TipAut 
	join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
	join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
	left join autsc asco on sc.RucE = asco.RucE and asco.CD_SCo = sc.Cd_SCo and cau.nomusu = asco.nomusu 
	where sc.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(sc.FecEmi)<=@Ejer
	and cau.nomusu = @usuario and asco.nomusu is null

	) as tabla 
	where Autoriza = 'SI'
END
GO

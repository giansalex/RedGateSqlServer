SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioOC] 
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from(
	select oc.cd_OC as 'DOC',
	case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, 1, ib_autcomniv, 0)) when 1 then 'NO' else 'SI' end) 
	else (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, niv, ib_autcomniv, 0)) when 1 then 'NO' 
	else (case (dbo.verificarAutNvl(@RucE, oc.cd_oc, niv-1, ib_autcomniv, 0)) when 1 then 'SI' else 'NO' end) end) end
	as 'Autoriza'
	from ordCompra oc 
	join CfgAutorizacion ca on oc.RucE = ca.RucE and ca.Cd_DMA = 'OC' and ca.Tipo = oc.TipAut 
	join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
	join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
	left join autoc aoc on oc.RucE = aoc.RucE and aoc.CD_OC = oc.Cd_OC and cau.nomusu = aoc.nomusu 
	where oc.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(oc.FecE)<=@Ejer
	and cau.nomusu = @usuario and aoc.nomusu is null
	) as tabla 
	where Autoriza = 'SI'
END
GO

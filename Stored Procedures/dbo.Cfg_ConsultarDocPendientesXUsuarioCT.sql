SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioCT]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from(
	select ct.cd_cot as 'DOC',
	case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, ct.cd_cot, 1, ib_autcomniv, 5)) when 1 then 'NO' else 'SI' end) 
	else ( case (dbo.verificarAutNvl(@RucE, ct.cd_cot, niv, ib_autcomniv, 5)) when 1 then 'NO' 
	else (case (dbo.verificarAutNvl(@RucE, ct.cd_cot, niv-1, ib_autcomniv, 5)) when 1 then 'SI' else 'NO' end) end) end
	as 'Autoriza'
	from cotizacion ct
	join CfgAutorizacion ca on ct.RucE = ca.RucE and ca.Cd_DMA = 'CT' and ca.Tipo = ct.TipAut 
	join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
	join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
	left join autcot act on ct.RucE = act.RucE and act.CD_Cot = ct.Cd_Cot and cau.nomusu = act.nomusu 
	where ct.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(ct.FecEmi)<=@Ejer
	and cau.nomusu = @usuario and act.nomusu is null

	) as tabla 
	where Autoriza = 'SI'
END
GO

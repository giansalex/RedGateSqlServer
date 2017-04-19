SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioSR]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from
	(
		select sr.cd_SR as 'DOC', 
		case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, sr.cd_sr, 1, ib_autcomniv, 3)) when 1 then 'NO' else 'SI' end) 
		else ( case (dbo.verificarAutNvl(@RucE, sr.cd_sr, niv, ib_autcomniv, 3)) when 1 then 'NO' 
		else (case (dbo.verificarAutNvl(@RucE, sr.cd_sr, niv-1, ib_autcomniv, 3)) when 1 then 'SI' else 'NO' end) end) end
		as 'Autoriza'
		from solicitudReq sr
		join CfgAutorizacion ca on sr.RucE = ca.RucE and ca.Cd_DMA = 'SR' and ca.Tipo = sr.TipAut 
		join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
		join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
		left join autsr asr on sr.RucE = asr.RucE and asr.CD_SR = sr.Cd_SR and cau.nomusu = asr.nomusu 
		where sr.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(sr.FecEmi)<=@Ejer
		and cau.nomusu = @usuario and asr.nomusu is null

	) as tabla 
	where Autoriza = 'SI'
END
GO

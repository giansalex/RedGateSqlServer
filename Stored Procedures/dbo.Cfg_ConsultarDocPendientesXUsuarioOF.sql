SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioOF]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from(
	select ofb.Cd_OF as 'DOC',
	case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, 1, ib_autcomniv, 4)) when 1 then 'NO' else 'SI' end) 
	else (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, niv, ib_autcomniv, 5)) when 1 then 'NO' 
	else (case (dbo.verificarAutNvl(@RucE, ofb.Cd_OF, niv-1, ib_autcomniv, 5)) when 1 then 'SI' else 'NO' end) end) end
	as 'Autoriza'
	from OrdFabricacion ofb
	join CfgAutorizacion ca on ofb.RucE = ca.RucE and ca.Cd_DMA = 'OF' and ca.Tipo = ofb.TipAut 
	join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
	join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
	left join autof aof on ofb.RucE = aof.RucE and aof.Cd_OF = ofb.Cd_OF and cau.nomusu = aof.nomusu 
	where ofb.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(ofb.FecE)<=@Ejer
	and cau.nomusu = @usuario and aof.nomusu is null

	) as tabla 
	where Autoriza = 'SI'
END
GO

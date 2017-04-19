SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Cfg_ConsultarDocPendientesXUsuarioOP]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	select Count(DOC) as Nro from(
	select op.cd_OP as 'DOC',
	case (niv) when 1 then (case (dbo.verificarAutNvl(@RucE, op.cd_op, 1, ib_autcomniv, 1)) when 1 then 'NO' else 'SI' end) 
	else ( case (dbo.verificarAutNvl(@RucE, op.cd_op, niv, ib_autcomniv, 1)) when 1 then 'NO' 
	else (case (dbo.verificarAutNvl(@RucE, op.cd_op, niv-1, ib_autcomniv, 1)) when 1 then 'SI' else 'NO' end) end) end
	as 'Autoriza'
	from ordPedido op 
	join CfgAutorizacion ca on op.RucE = ca.RucE and ca.Cd_DMA = 'OP' and ca.Tipo = op.TipAut 
	join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
	join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
	left join autop aop on op.RucE = aop.RucE and aop.CD_OP = op.Cd_OP and cau.nomusu = aop.nomusu 
	where op.RucE = @RucE and (IB_Aut is null or IB_Aut = 0) and TipAut !=0 and YEAR(op.FecE)<=@Ejer
	and cau.nomusu = @usuario and aop.nomusu is null

	) as tabla 
	where Autoriza = 'SI'
END

--Pruebas:
 --exec dbo.Cfg_ConsultarDocPendientesXUsuarioOP '20160000001','2016','ADMIN'
GO

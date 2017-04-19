SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_ConsultarDocPendientesXUsuario4]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
as


--ORDENES DE COMPRA-----------------------------------------------------------------------------------------------
SELECT Tipo, case(Tipo) when 'OC' then 'Órdenes de compra' 
else (case(Tipo) when 'SR' then 'Solicitudes de requerimiento' 
else (case(Tipo) when 'OP' then 'Órdenes de pedido' 
else (case(Tipo) when 'SC' then 'Solicitudes de compra' 
else (case(Tipo) when 'CT' then 'Cotizaciones'
else (case(Tipo) when 'OF' then 'Órdenes de fabricacion'
else '' end) end) end) end) end) end as 'COD', count(doc) as 'Docs' 
FROM (
select * from (
select DOC , 'OC' as Tipo from(
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
) as OC
union all
--ORDENES DE PEDIDO-----------------------------------------------------------------------------------------------
select * from (
select DOC, 'OP' as Tipo from(
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
) as OP
union all
--SOLICITUD DE COMPRA---------------------------------------------------------------------------------------------
select * from (
select DOC, 'SC' as Tipo from(
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
) as SC
union all
--SOLICITUD DE REQUERIMIENTOS-------------------------------------------------------------------------------------
select * from (
select DOC, 'SR' as Tipo from(
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
) as SR
union all
--COTIZACION------------------------------------------------------------------------------------------------------
select * from (
select DOC, 'CT' as Tipo from(
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
) as CT
union all
--ORDER DE FABRICACION--------------------------------------------------------------------------------------------
select * from (
select DOC, 'OF' as Tipo from(
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
) as OFB

) as DOCUMENTOS
group by Tipo


--exec user321.Cfg_ConsultarDocPendientesXUsuario3 '11111111111','2011','mmedrano'
--exec user321.Cfg_ConsultarDocPendientesXUsuario4 '20160000001','2016','ADMIM'
GO

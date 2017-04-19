SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_ConsultarDocPendientesXUsuario2]
@RucE nvarchar(11),
@Ejer varchar(4),
@usuario varchar(10)
as

select cd_dma,
case(cd_dma) when 'OC' then 'Órdenes de compra' 
else (case(cd_dma) when 'SR' then 'Solicitudes de requerimiento' else (case(cd_dma) when 'OP' then 'Órdenes de pedido' else (case(cd_dma) when 'SC' then 'Solicitudes de compra' else '' end ) end ) end) end as 'COD',

count(*) as 'Docs' from (
select ac.cd_dma, isnull(oc.cd_oc, isnull(sc.cd_sco, isnull(op.cd_op, isnull(sr.cd_sr, '')))) as CD_DOC, 
isnull(asr.cd_sr, isnull(aop.cd_op, isnull(atsc.cd_sco, isnull(aoc.cd_oc, '')))) as CD_DOC_AUT
from cfgautsxusuario cau
join cfgnivelaut cn on nomusu = @usuario and cn.id_niv = cau.id_niv
join cfgautorizacion ac on ac.RucE = @RucE and ac.id_aut = cn.id_aut
left join ordcompra oc on oc.RucE = @RucE and ac.cd_dma = 'OC' and oc.tipaut = ac.tipo and YEAR(oc.FecE)<=@Ejer and (oc.ib_aut = 0 or oc.ib_aut is null)
left join autoc aoc on aoc.RucE = @RucE and aoc.NomUsu = @usuario and oc.cd_oc = aoc.cd_oc
left join solicitudcom sc on sc.RucE = @RucE and ac.cd_dma = 'SC' and sc.tipaut = ac.tipo and YEAR(sc.FecEmi)<=@Ejer and (sc.ib_aut = 0 or sc.ib_aut is null)
left join autsc atsc on atsc.RucE = @RucE and atsc.NomUsu = @usuario and sc.cd_sco = atsc.cd_sco
left join ordpedido op on op.RucE = @RucE and ac.cd_dma = 'OP' and op.tipaut = ac.tipo and YEAR(op.FecE)<=@Ejer and (op.ib_aut = 0 or op.ib_aut is null)
left join autop aop on aop.RucE = @RucE and aop.NomUsu = @usuario and op.cd_op = aop.cd_op
left join solicitudreq sr on sr.RucE = @RucE and ac.cd_dma = 'SR' and sr.tipaut = ac.tipo and YEAR(sr.FecEmi)<=@Ejer and (sr.ib_aut = 0 or sr.ib_aut is null)
left join autsr asr on asr.RucE = @RucE and asr.NomUsu = @usuario and sr.cd_sr = asr.cd_sr
where oc.cd_oc is not null or sr.cd_sr is not null or op.cd_op is not null or sc.cd_sco is not null
) Tabla
where cd_doc != cd_doc_aut
group by cd_dma
order by cd_dma

--exec Cfg_ConsultarDocPendientesXUsuario2 '11111111111','2011','mmedrano'

GO

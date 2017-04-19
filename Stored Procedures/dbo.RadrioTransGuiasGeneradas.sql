SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Saavedra,Juan Antonio>
-- Create date: <28/11/2012-12:15pm>
-- Description:	<Reporte para Radiotrans deon pide las Guias con su factura y a la vez su NotaCredito>
--
-- =============================================

create PROCEDURE [dbo].[RadrioTransGuiasGeneradas]

	@RucE varchar(11),
	@FecInicio datetime,
	@FecFinal datetime
AS
set language spanish 
BEGIN
select e.*,'DEL '+Convert(nvarchar,@FecInicio,103)+ ' AL '+Convert(nvarchar,@FecFinal,103) as FecCons from empresa e where e.Ruc=@RucE
select t.*,w.* from 
(
SELECT     
            GuiaXVenta.Cd_Vta, 
            (GuiaRemision.NroSre +'-'+GuiaRemision.NroGR) AS NroGuia,             
            GuiaRemision.FecEmi, 
            case (GuiaRemision.Estado) when 1 then 'Anulada' else 'Facturada' end as Estado , 
            Cliente2.RSocial as cliente
FROM        GuiaRemision inner JOIN
            Cliente2 ON GuiaRemision.RucE = Cliente2.RucE AND Cliente2.Cd_clt=GuiaRemision.Cd_Clt
            LEFT OUTER JOIN
            GuiaXVenta ON GuiaRemision.RucE = GuiaXVenta.RucE AND GuiaRemision.Cd_GR = GuiaXVenta.Cd_GR
            WHERE GuiaRemision.RucE = @RucE and GuiaRemision.FecEmi between @FecInicio and @FecFinal
)
 as t left join 
(
    SELECT     
    Cd_Vta, 
    DR_CdTD,
    (DR_NSre+'-'+DR_NDoc) as NroFactura,    
    case (IB_Anulado) when 1 then 'Anulado' else '' end as Estado ,    
    (NroSre+'-'+NroDoc)  as NroSeCred   
   FROM Venta
    WHERE  RucE = @RucE 
) as w on t.Cd_Vta = w.Cd_Vta
 order by NroGuia
END
GO

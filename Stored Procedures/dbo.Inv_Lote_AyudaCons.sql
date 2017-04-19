SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_AyudaCons]
@RucE nvarchar(11),
@Cd_Prod nchar(10),
@msj varchar(100) output
as
/*
select l.Cd_Lote, l.NroLote,
isnull(case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + ' ' + p.ApMat + ' ' + p.Nom else p.RSocial end, 'Sin Proveedor') as LoteProveedor,
SUM(pl.Cant) as Stock
from ProductoxLote as pl
left join Lote as l on l.RucE = pl.RucE and l.Cd_Lote = pl.Cd_Lote
left join Proveedor2 p on p.RucE = l.RucE and p.Cd_Prv = l.Cd_Prov
where pl.RucE = @RucE and Cd_Prod = @Cd_Prod
group by l.Cd_Lote,l.NroLote,pl.Cd_Prod,isnull(case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + ' ' + p.ApMat + ' ' + p.Nom else p.RSocial end, 'Sin Proveedor')
*/
select Cd_Lote,NroLote,LoteProveedor,Stock from Inv_LoteSalidaAyudaCons
where RucE = @RucE and Cd_Prod =@Cd_Prod and Stock > 0

-- LEYENDA
-- CAM 03/12/2012 creación
-- exec Inv_Lote_AyudaCons '11111111111','PD00001',''
--
-- CAM 22/03/2013 Modificacion
-- exec Inv_Lote_AyudaCons '11111111111','PD00001',''
--
GO

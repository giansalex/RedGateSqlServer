SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
CREATE Procedure [dbo].[Rpt_TotalInventarioPersonalizado]
@RucE nvarchar(11), /*@Ejer nvarchar(4),*/@FecIni datetime,@FecFin datetime
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @FecIni = '01/08/2012'
--set @FecFin = '31/08/2012'
 as 
select 
i.*,p.*,pum.*,um.*,clt.*,prv.*
from Inventario i 
left join Producto p on p.RucE = i.RucE and p.Cd_Pro = i.Cd_Prod
left join Prod_UM pum on pum.RucE = i.RucE and pum.Cd_Prod = i.Cd_Prod and pum.ID_UMP = i.ID_UMP
left join UnidadMedida um on um.Cd_UM = pum.Cd_UM
left join Cliente2 clt on clt.RucE = i.RucE and clt.Cd_Clt = i.Cd_Clt
left join Proveedor2 prv on prv.RucE = i.RucE and prv.Cd_Prv = i.Cd_Prv
where i.RucE = @RucE /*and i.Ejer = @Ejer*/ and i.FecMov between @FecIni and @FecFin

--exec Rpt_TotalInventarioPersonalizado '11111111111','01/08/2012','31/08/2012'
GO

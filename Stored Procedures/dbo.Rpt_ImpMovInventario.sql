SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
CREATE Procedure [dbo].[Rpt_ImpMovInventario]
@RucE nvarchar(11),
@Ejer nvarchar(4),
 @RegCtb nvarchar(15) -- @Cd_Inv nvarchar(12),
--set @RucE = '11111111111'
--set @Ejer = '2011'
----set @Cd_Inv = ''
--set @RegCtb = 'INGE_LD12-00010'
--exec [Rpt_ImpMovInventario] '11111111111','2012','INGE_LD01-00006'
as 
select 
e.RSocial,
inv.RucE,
inv.Ejer,
inv.RegCtb,
p.Nombre1 as NomProd, 
p.Descrip, 
p.CodCo1_ as CodCom,
case isnull(inv.IC_ES,'') when 'E' then 'Entrada' when 'S' then 'Salida' end as IC_ES,
inv.Cd_MIS,
mis.Descrip as MotIngSal,
inv.ID_UMP,
um.Nombre,
um.NCorto,
ump.Factor,
inv.Cd_Alm,
inv.Cd_Area,
inv.Cd_CC,
inv.Cd_SC,
inv.Cd_SS,
case when ISNULL(inv.Cd_Clt,'')<>'' then inv.Cd_Clt
	when ISNULL(inv.Cd_Prv,'') <> '' then inv.Cd_Prv
	else 'Sin Cod Cliente Proveedor' end as Cd_PrvClt,

case when ISNULL(inv.Cd_Clt,'')<>'' then clt.NDoc
	when ISNULL(inv.Cd_Prv,'')<> '' then prv.NDoc
	else 'Sin Documento' end as NDoc_CltPrv,


case (isnull(len(inv.Cd_Clt),0)) when 0 then 
case(isnull(len(inv.Cd_Prv),0)) when 0 then 'Sin Cliente - Proveedor'
else 
case(isnull(len(prv.RSocial),0)) when 0 then isnull(nullif(prv.ApPat +' '+prv.ApMat+' '+prv.Nom,''),'------- SIN NOMBRE ------') else prv.RSocial  end  
end
else 
case(isnull(len(clt.RSocial),0)) when 0 then isnull(nullif(clt.ApPat +' '+clt.ApMat+' '+clt.Nom,''),'------- SIN NOMBRE ------') else clt.RSocial end 
end 
as NomCltPrv,
Convert(nvarchar,inv.FecMov,103) as FecMov,
inv.Cd_Mda,
inv.Cant,--cantidad real
inv.Cant_Ing,--cantidad ingresada
inv.CosUnt,
inv.CosUnt_ME,
inv.Total,
inv.Total_ME,
case when ISNULL(inv.Cd_GR,'')<>'' then inv.Cd_GR else 
case when ISNULL(inv.Cd_OC,'')<>'' then inv.Cd_OC else 
case when ISNULL(inv.Cd_Vta,'')<> '' then inv.Cd_Vta else
case when ISNULL(inv.Cd_Com,'') <> '' then inv.Cd_Com else
case when ISNULL(inv.Cd_OP,'') <> '' then inv.Cd_OP else
case when ISNULL(inv.Cd_OF,'') <> '' then inv.Cd_OF else 
case when ISNULL(inv.Cd_SR,'') <> '' then inv.Cd_SR else 'Sin Documento' 
end end end end end end end as Cd_Doc

from Inventario inv
left join Empresa e on inv.RucE = e.Ruc
left join Producto2 p on inv.RucE = p.RucE and inv.Cd_Prod = p.Cd_Prod
left join Prod_UM ump on inv.RucE = ump.RucE and inv.Cd_Prod = ump.Cd_Prod and inv.ID_UMP = ump.ID_UMP
left join UnidadMedida um on um.Cd_UM = ump.Cd_UM  
left join MtvoIngSal mis on inv.RucE = mis.RucE and inv.Cd_MIS = mis.Cd_MIS
left join Proveedor2 prv on inv.RucE = prv.RucE and inv.Cd_Prv = prv.Cd_Prv
left join Cliente2 clt on inv.RucE = clt.RucE and inv.Cd_Clt = clt.Cd_Clt

where 
inv.RucE = @RucE and 
inv.Ejer = @Ejer and 
inv.RegCtb = @RegCtb




GO

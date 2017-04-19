SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ImpNotaEntSal]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15)
--set @RucE = '20102028687'
--set @Ejer = '2013'
----set @Cd_Inv = ''
--set @RegCtb = 'INLP_LD01-00027'
--exec [Rpt_ImpNotaEntSal] '20102028687','2013','INLP_LD01-00027'
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
isnull(inv.IC_ES,'') as ICES,
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
inv.FecMov,
inv.Cd_Mda,
abs(case when isnull(pl.Cant,0) = 0 then inv.Cant else pl.Cant end) as Cant,--cantidad real
inv.Cant_Ing,--cantidad ingresada
inv.CosUnt,
inv.CosUnt_ME,
inv.Total,
inv.Total_ME,
/****Documento que genera el inventario***************/
case when ISNULL(inv.Cd_GR,'')<>'' then inv.Cd_GR else '--Sin documento--' end as Cd_Doc,
gr.Cd_TD,
gr.NroSre,
gr.NroGR,
gr.Obs as ObsGR,
gr.UsuCrea as UsuCreaGR,
usuGR.NomComp as NomCompUsuCreaGR,
/****************************************************/
/*****Documento con el que se genera inventario*****/
inv.Cd_TDES,
inv.Cd_TD,
inv.NroSre,
inv.NroDoc,
/****************************************************/
l.NroLote,
l.Cd_Lote,
l.Descripcion,
l.FecFabricacion,
l.FecCaducidad,
l.UsuCrea,
l.UsuModf,
l.FecReg as FecRegLote,
l.FecModf as FecModfLote,
usu.NomComp as NomCompUsuCrea,
inv.UsuCrea as UsuCreaInv
from Inventario inv
left join Guiaremision gr on gr.RucE = inv.RucE and gr.Cd_GR = inv.Cd_GR
left join ProductoxLote pl on pl.RucE = inv.RucE and pl.Ejer = inv.ejer and pl.RegCtbInv = inv.RegCtb and pl.Cd_Prod = inv.Cd_Prod
left join Lote l on l.RucE = inv.RucE and l.Cd_Lote = pl.Cd_Lote
left join Empresa e on inv.RucE = e.Ruc
left join Producto2 p on inv.RucE = p.RucE and p.Cd_Prod = isnull(pl.Cd_Prod,inv.Cd_Prod)
left join Prod_UM ump on inv.RucE = ump.RucE and inv.Cd_Prod = ump.Cd_Prod and inv.ID_UMP = ump.ID_UMP
left join UnidadMedida um on um.Cd_UM = ump.Cd_UM  
left join MtvoIngSal mis on inv.RucE = mis.RucE and inv.Cd_MIS = mis.Cd_MIS
left join Proveedor2 prv on inv.RucE = prv.RucE and prv.Cd_Prv = l.Cd_Prov
left join Cliente2 clt on inv.RucE = clt.RucE and inv.Cd_Clt = clt.Cd_Clt
left join usuario usu on usu.NomUsu=inv.UsuCrea
left join usuario usuGR on usuGR.NomUsu = gr.UsuCrea

where 
inv.RucE = @RucE and 
inv.Ejer = @Ejer and 
inv.RegCtb = @RegCtb



--creado <03/04/2013: JA>
--select * from tipDoc



GO

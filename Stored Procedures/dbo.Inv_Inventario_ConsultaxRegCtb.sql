SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Inventario_ConsultaxRegCtb]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@msj varchar(100) output

as
--set language 'spanish'
select 
				cast(0 as bit) as Sel, Inv.Cd_Inv, Inv.RegCtb, Inv.Cd_Prod, Prod.CodCo1_ as CodCom, Prod.Nombre1 as Producto, Inv.ID_UMP, PUM1.DescripAlt as Descrip1,
				Inv.ID_UMBse, PUM2.DescripAlt as Descrip2, PUM1.Factor, Inv.Cd_Alm, Alm.Nombre as Almacen, Inv.Cd_Area, Ar.Descrip as Area,
				c.Cd_CC + ' - ' + c.Descrip as Cd_CC,
				s.Cd_SC + ' - ' + s.Descrip as Cd_SC,
				ss.Cd_SS + ' - ' + ss.Descrip as Cd_SS,
				Inv.Cd_Prv,Prv.NDOC as NDOC_Prv, case when Prv.RSocial is not null then Prv.RSocial else (isnull(Prv.ApPat,'') +' '+ isnull(Prv.ApMat,'') + ' '+ isnull(Prv.Nom,'')) end as Proveedor,
				Inv.Cd_Clt,Clt.NDOC as NDOC_Clt, case when Clt.RSocial is not null then Clt.RSocial else (isnull(Clt.ApPat,'') +' '+ isnull(Clt.ApMat,'') + ' '+ isnull(Clt.Nom,'')) end as Cliente,
				Case(Inv.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES, Mtvo.Descrip as 'Mot_Ing_Sal', Inv.Cd_MIS,
				Inv.FecMov, Abs(Inv.Cant_Ing) as Cant_Ing, Abs(Inv.Cant) as Cant, Abs(Inv.CosUnt) as CosUnt, Abs(Inv.Total) as Total, Inv.Cd_Gr,
				Inv.CA01, Inv.CA02, Inv.CA03, Inv.CA04, Inv.CA05, Inv.Cd_Vta, Inv.Cd_OP, Inv.Cd_Com, Inv.Cd_OC, Inv.Cd_SR, Inv.Cd_OF, Inv.UsuCrea,
				Mda.Cd_Mda, Mda.Nombre as NombreMda from
inventario Inv inner join Producto2 Prod on Prod.Cd_Prod=Inv.Cd_Prod and Inv.RucE=Prod.RucE
				inner join Prod_UM PUM1 on PUM1.ID_UMP=Inv.ID_UMP and Inv.RucE=PUM1.RucE and Inv.Cd_Prod=PUM1.Cd_Prod
				inner join Prod_UM PUM2 on PUM2.ID_UMP=Inv.ID_UMBse and Inv.RucE=PUM2.RucE and Inv.Cd_Prod=PUM2.Cd_Prod
				inner join Almacen Alm on Alm.Cd_Alm=Inv.Cd_Alm and Alm.RucE=Inv.RucE
				left join Area Ar on Ar.Cd_Area=Inv.Cd_Area and Inv.RucE=Ar.RucE
				left join Proveedor2 Prv on Prv.Cd_Prv=Inv.Cd_Prv and Inv.RucE=Prv.RucE
				left join Cliente2 Clt on Clt.Cd_Clt=Inv.Cd_Clt and Inv.RucE=Clt.RucE
				left join MtvoIngSal Mtvo on Mtvo.Cd_MIS=Inv.Cd_MIS and Inv.RucE=Mtvo.RucE
				left join Moneda mda on mda.Cd_Mda = Inv.Cd_Mda
				left join CCostos c on c.RucE = Inv.RucE and c.Cd_CC = Inv.Cd_CC
				left join CCSub s on c.RucE = s.RucE and c.Cd_CC = s.Cd_CC and s.Cd_SC = Inv.Cd_SC
				left join CCSubSub ss on c.RucE = ss.RucE and c.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = Inv.Cd_SS where 
				Inv.RucE=@RucE and Inv.FecMov between @FecD and @FecH order by Inv.FecMov
-- LEYENDA
-- Cam 12/04/2012 creacion
GO

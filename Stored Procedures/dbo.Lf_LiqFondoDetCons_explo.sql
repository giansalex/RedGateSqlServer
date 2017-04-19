SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Lf_LiqFondoDetCons_explo]
@RucE nvarchar(11),
@Cd_Liq char(10),
@msj varchar(100) output
as
select ld.RucE, ld.Cd_liq, ld.Item, 
	   Convert(nvarchar,ld.FecMov,103) as FecmMov, ld.Cd_TD, ld.NroSre, ld.NroDoc,
	   Convert(nvarchar,ld.FecED,103) as FecED,
	   Convert(nvarchar,ld.FecVD,103) as FecVD,
	   ld.Cd_Prod, pro.Nombre1 as nomProd, ld.ID_UMP, um.DescripAlt as nomUMP , ld.Cd_Srv,
	   ld.ValorU, ld.DsctoP,ld.DsctoI, ld.BIMU, ld.IGVU, ld.TotalU, ld.Cantidad, ld.BIM, ld.IGV, ld.Total,
	   isnull(ld.Cd_Prv,'-') as Cd_Prv,
	   isnull(ld.Cd_Clt,'-') as Cd_Clt,
	   isnull((case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'')+' '+isnull(c2.ApMat,'')+', '+isnull(c2.Nom,'') else c2.RSocial end),'-') as Cliente,
	   isnull((case(isnull(len(p2.RSocial),0)) when 0 then isnull(p2.ApPat,'')+' '+isnull(p2.ApMat,'')+'- '+isnull(p2.Nom,'') else p2.RSocial end),'-') as Proveedor,
	   ld.Cd_Area, ld.Cd_CC, ld.Cd_SC, ld.Cd_SS, ld.Cd_Mda, ld.CamMda
	   from LiquidacionDet ld
	inner join Cliente2 c2 on c2.RucE=ld.RucE and c2.Cd_Clt=ld.Cd_Clt
	inner join Proveedor2 p2 on p2.RucE=ld.RucE and p2.Cd_Prv=ld.Cd_Prv
	inner join producto2 pro on pro.RucE=ld.RucE and pro.Cd_Prod=ld.Cd_Prod
	inner join prod_UM um on pro.RucE=ld.RucE and pro.Cd_Prod=um.Cd_Prod and um.ID_UMP = ld.ID_UMP
	where ld.RucE=@RucE and ld.Cd_Liq=@Cd_Liq

print @msj

--SP:
-- Ce: 27/02/2013 <Creacion de SP>
-- Lf_LiqFondoDetCons_explo '11111111111','LF00000001',null
GO

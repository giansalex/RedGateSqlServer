SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioConsXProd_paCot1_2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Id_UMP int,
@msj varchar(100) output

as

declare @check bit
set @check=0
select 
	@check as Sel,
	c.Cd_Prod AS Cd_Prod,
	c.ID_Prec as Item,
	c.Descrip as Descrip,
	c.Cd_Mda as Cd_Mda,
	m.Simbolo as Simbolo,
	h.ID_UMP as ID_UMP,
	h.DescripAlt as UndMed,
	h.Factor as Factor,
	c.ValVta as ValVta,
	Convert(nvarchar,c.MrgUti)+Case(c.IC_TipMU) when 'I' then '' else '%' end as ValUti,
	c.IC_TipMU as TipUti,
	Convert(nvarchar,c.Dscto)+Case(c.IC_TipDscto) when 'I' then '' else '%' end as Dsct,
	c.IC_TipDscto as TipDsct,
	--c.ValVta-isnull(c.Dscto,0) as Neto,
	c.ValVta - ((c.ValVta * isnull(c.Dscto,0))/100) as Neto,
	c.IB_IncIGV as IncIgv,
	--case c.IB_IncIGV when 1 then Convert(decimal(13,2),(c.ValVta-isnull(c.Dscto,0))*(user123.Igv()/100)) else 0 end as  IGV,
	case c.IB_IncIGV when 1 then Convert(decimal(13,2),(c.ValVta - ((c.ValVta * isnull(c.Dscto,0))/100))*(user123.Igv()/100)) else 0 end as  IGV,
	--Convert(decimal(13,2),(c.ValVta-isnull(c.Dscto,0))*(user123.Igv()/100)) as  Igv,
	isnull(mp.PorcentajePercep,0) as PercepP,
	c.PVta as PreVta
from Precio c 
left join maestrapercepciones mp on mp.RucE=c.RucE and mp.Cd_Prod=c.Cd_Prod
left join Prod_UM h On h.RucE=c.RucE and h.Cd_Prod=c.Cd_Prod and h.ID_UMP=c.ID_UMP
left join Moneda m On m.Cd_Mda=c.Cd_Mda --order by c.ID_UMP
where c.RucE=@RucE and c.Cd_Prod=@Cd_Prod and c.Estado=1 and c.Id_UMP=@Id_UMP

--AC 07/01/2013: Modificacion resta de porcentajes de descuentos  
--AC 13/03/2013: Ingreso de Porcentaje de percepcion  
--select * from maestrapercepciones
GO

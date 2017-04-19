SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvConsXSrv_paCot]

--exec Inv_PrecioSrvConsXSrv_paCot '11111111111','SRV0001',null

@RucE nvarchar(11),
@Cd_Srv char(7),
@msj varchar(100) output

as


declare @check bit
set @check=0

select
	@check as Sel,
	p.Cd_Srv,
	p.ID_PrSv as Item,
	p.Descrip,
	p.Cd_Mda,
	s.Simbolo,
	p.ValVta,
	Convert(nvarchar,p.Dscto)+Case(p.IC_TipDscto) when 'I' then '' else '%' end as Dsct,
	p.IC_TipDscto as TipDsct,
	Convert(decimal(13,4),p.ValVta-Case(p.IC_TipDscto) when 'I' then isnull(p.Dscto,0) else p.ValVta*(p.Dscto/100) end) as Neto,
	p.IB_IncIGV as IncIgv,
	Case(p.IB_IncIGV) when 1 then Convert(decimal(13,4),((p.ValVta-isnull(p.Dscto,0))*(user123.IGV()/100))) else 0.00 end as Igv,
	p.PVta as PreVta
from PrecioSrv p
left join Moneda s On s.Cd_Mda=p.Cd_Mda
where p.RucE=@RucE and p.Cd_Srv=@Cd_Srv and p.Estado=1

-- Leyedan --

--DI : 06/04/2010 <Creacion del procedimiento almacenado>
--CE:  18/09/2012 <Modificacion a 4 decimales>
GO

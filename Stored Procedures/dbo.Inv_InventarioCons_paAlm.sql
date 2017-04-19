SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_paAlm]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Alm varchar(20),
@FecD datetime,
@FecH datetime,
@msj varchar(100) output
as
select  a.Cd_Inv, a.RegCtb, a.ID_UMP, b.DescripAlt as Descrip1,a.ID_UMBse,c.DescripAlt as Descrip2,
	a.Cd_Prod, d.Nombre1 as NombreProducto,a.Cd_Alm, f.Nombre as NombreAlmacen,convert(varchar,a.FecMov,103) as FecMov, 
	case(a.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,  e.Descrip as Motivo,
	case(a.IC_ES) when 'E' then Convert(nvarchar,a.Cant) else '-' end as ECant,
	case(a.IC_ES) when 'E' then Convert(nvarchar,a.CosUnt) else '-' end as ECosUnt,
	case(a.IC_ES) when 'E' then Convert(nvarchar,a.Total) else '-' end as ETotal,
	case(a.IC_ES) when 'S' then Convert(nvarchar,a.Cant*-1) else '-'end as SCant,
	case(a.IC_ES) when 'S' then Convert(nvarchar,a.CosUnt) else '-' end as SCosUnt,
	case(a.IC_ES) when 'S' then Convert(nvarchar,a.Total*-1) else '-' end as STotal,
	(SELECT sum(h.cant) FROM Inventario h  WHERE (h.Cd_Inv <= a.Cd_Inv) and (h.RucE=@RucE and h.Cd_Prod=@Cd_Prod)
		and (h.Cd_Alm=@Cd_Alm) and h.FecMov between (convert(varchar, @FecD,103)) and (convert(varchar, @FecH,103)))
	as Suma_Cant
from 	Inventario a inner join Prod_UM b on  b.ID_UMP=a.ID_UMP and a.RucE=b.RucE and a.Cd_Prod=b.Cd_Prod
	inner join Prod_UM c on c.ID_UMP=a.ID_UMP and a.RucE=c.RucE and a.Cd_Prod=c.Cd_Prod
	inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and a.RucE=d.RucE
	left join mtvoIngSAl e on e.Cd_MIS=a.Cd_MIS and a.RucE=e.RucE
	inner join Almacen f on f.Cd_Alm=a.Cd_Alm and a.RucE=f.RucE
where 	a.RucE=@RucE and a.Cd_Prod=@Cd_Prod and a.Cd_Alm=@Cd_Alm and a.FecMov between (convert(varchar,@FecD,103)) and (convert(varchar,@FecH,103))
print @msj
-- Leyenda --
-- JJ : 2010-07-13	: <Creacion del procedimiento almacenado>
-- JJ : 2010-07-16	: <Modificacion del procedimiento almacenado>
GO

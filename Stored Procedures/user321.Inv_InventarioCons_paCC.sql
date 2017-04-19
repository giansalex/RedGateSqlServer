SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----------------------------------------------------------------------------
CREATE procedure [user321].[Inv_InventarioCons_paCC] -- Consulta de Inventario x Centro de Costos
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecD datetime,
@FecH datetime,
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output
as
if(@Cd_SC='' and @Cd_SS='' or @Cd_SC is null and @Cd_SS is null)
begin
	select d.Cd_Inv, d.RegCtb, d.ID_UMP, q.DescripAlt as Descript1, d.ID_UMBse,z.DescripAlt as Descript2, d.Cd_Prod, c.Nombre1 as NombreProducto, 
		case(d.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,u.Descrip as Motivo,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Cant) else '-' end as ECant,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.CosUnt) else '-' end as ECosUnt,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Total) else '-' end as ETotal,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Cant*-1) else '-' end as SCant,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.CosUnt) else '-' end as SCosUnt,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Total*-1) else '-' end as STotal,
		(SELECT sum(a.cant) FROM Inventario a  WHERE (a.Cd_Inv <= d.Cd_Inv) and (a.RucE=@RucE and a.Cd_Prod=@Cd_Prod)
			and (a.Cd_CC=@Cd_CC) and a.FecMov between (convert(varchar, @FecD,103)) and (convert(varchar, @FecH,103)))
		as Suma_Cant, d.Cd_CC,d.Cd_SC,d.Cd_SS,d.Cd_GR,d.CA01,d.CA02,d.CA03,d.CA04,d.CA05
	from   Inventario d left join  CCostos b on b.Cd_CC=d.Cd_CC and b.RucE=d.RucE
	       inner join Producto2 c on c.Cd_Prod=d.Cd_Prod and d.RucE=c.RucE
	       inner join Prod_UM q on q.ID_UMP=d.ID_UMP and d.RucE=q.RucE and d.Cd_Prod=q.Cd_Prod
	       inner join Prod_UM z on z.ID_UMP=d.ID_UMBse and d.RucE=z.RucE and d.Cd_Prod=z.Cd_Prod
	       left join  MtvoIngSal u on u.Cd_MIS=d.Cd_MIS and d.RucE=u.RucE
	where d.RucE=@RucE and d.Cd_Prod=@Cd_Prod and d.Cd_CC like (@Cd_CC) and d.FecMov between (convert(varchar, @FecD,103)) and (convert(varchar, @FecH,103))
end
else if(@Cd_SS='' or @Cd_SS is null)
begin
	select d.Cd_Inv, d.RegCtb, d.ID_UMP, q.DescripAlt as Descript1, d.ID_UMBse,z.DescripAlt as Descript2, d.Cd_Prod, c.Nombre1 as NombreProducto, 
		case(d.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,u.Descrip as Motivo,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Cant) else '-' end as ECant,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.CosUnt) else '-' end as ECosUnt,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Total) else '-' end as ETotal,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Cant*-1) else '-' end as SCant,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.CosUnt) else '-' end as SCosUnt,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Total*-1) else '-' end as STotal,
		(SELECT sum(a.cant) FROM Inventario a  WHERE (a.Cd_Inv <= d.Cd_Inv) and (a.RucE=@RucE and a.Cd_Prod=@Cd_Prod)
			and (a.Cd_CC=@Cd_CC) and a.FecMov between (convert(varchar, @FecD,103)) and (convert(varchar, @FecH,103)))
		as Suma_Cant, d.Cd_CC,d.Cd_SC,d.Cd_SS,d.Cd_GR,d.CA01,d.CA02,d.CA03,d.CA04,d.CA05
	from   Inventario d left join  CCostos b on b.Cd_CC=d.Cd_CC and b.RucE=d.RucE
	       inner join Producto2 c on c.Cd_Prod=d.Cd_Prod and d.RucE=c.RucE
	       inner join Prod_UM q on q.ID_UMP=d.ID_UMP and d.RucE=q.RucE and d.Cd_Prod=q.Cd_Prod
	       inner join Prod_UM z on z.ID_UMP=d.ID_UMBse and d.RucE=z.RucE and d.Cd_Prod=z.Cd_Prod
	       left join  MtvoIngSal u on u.Cd_MIS=d.Cd_MIS and d.RucE=u.RucE
	where (d.RucE=@RucE and d.Cd_Prod=@Cd_Prod) and (d.Cd_CC=@Cd_CC and d.Cd_SC like (@Cd_SC)) and d.FecMov between convert(varchar, @FecD,103) and Convert(varchar,@FecH,103)
end
else
begin
	select d.Cd_Inv, d.RegCtb, d.ID_UMP, q.DescripAlt as Descript1, d.ID_UMBse,z.DescripAlt as Descript2, d.Cd_Prod, c.Nombre1 as NombreProducto, 
		case(d.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,u.Descrip as Motivo,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Cant) else '-' end as ECant,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.CosUnt) else '-' end as ECosUnt,
		case(d.IC_ES) when 'E' then Convert(nvarchar,d.Total) else '-' end as ETotal,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Cant*-1) else '-' end as SCant,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.CosUnt) else '-' end as SCosUnt,
		case(d.IC_ES) when 'S' then Convert(nvarchar,d.Total*-1) else '-' end as STotal,
		(SELECT sum(a.cant) FROM Inventario a  WHERE (a.Cd_Inv <= d.Cd_Inv) and (a.RucE=@RucE and a.Cd_Prod=@Cd_Prod)
			and (a.Cd_CC=@Cd_CC) and a.FecMov between (convert(varchar, @FecD,103)) and (convert(varchar, @FecH,103)))
		as Suma_Cant, d.Cd_CC,d.Cd_SC,d.Cd_SS,d.Cd_GR,d.CA01,d.CA02,d.CA03,d.CA04,d.CA05
	from   Inventario d left join  CCostos b on b.Cd_CC=d.Cd_CC and b.RucE=d.RucE
	       inner join Producto2 c on c.Cd_Prod=d.Cd_Prod and d.RucE=c.RucE
	       inner join Prod_UM q on q.ID_UMP=d.ID_UMP and d.RucE=q.RucE and d.Cd_Prod=q.Cd_Prod
	       inner join Prod_UM z on z.ID_UMP=d.ID_UMBse and d.RucE=z.RucE and d.Cd_Prod=z.Cd_Prod
	       left join  MtvoIngSal u on u.Cd_MIS=d.Cd_MIS and d.RucE=u.RucE
	where (d.RucE=@RucE and d.Cd_Prod=@Cd_Prod) and (d.Cd_CC=@Cd_CC and d.Cd_SC=@Cd_SC and d.Cd_SS=@Cd_SS) and d.FecMov between convert(varchar, @FecD,103) and Convert(varchar,@FecH,103)
	
end
print @msj
-- Leyenda --
-- JJ : 2010-07-10	: <Creacion del procedimiento almacenado>
-- JJ : 2010-07-16	: <Modificacion del procedimiento almacenado>


GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Inv_InventarioCons_ExploGenTotales]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@msj varchar(100) output

as

select  'Total >>>>' as 'TextoTotal', sum(ECant) as 'ESaldoCant', sum(Etotal) as 'ECostoTotal', sum(SCant) as 'SSaldoTotal', 
	sum(STotal) as 'SCostoTotal', sum(SldoCosto) as 'TotalSaldo'
from(
	select *, ECant-SCant as Suma_Cantidad, ETotal-STotal as SldoCosto, 
	case(ECant-SCant) when 0 then 0 else abs((ETotal-STotal)/(ECant-SCant)) end as CostoProm 
	from(
		select a.Cd_Prod,d.Nombre1 as NombreProducto , d.Descrip,
		sum(Case(a.IC_ES) when 'E' then a.Cant else 0 end) as ECant,
		sum(Case(a.IC_ES) when 'E' then a.Total else 0 end) as ETotal,
		abs(sum(Case(a.IC_ES) when 'S' then Cant else 0 end)) as SCant,
		abs(sum(Case(a.IC_ES) when 'S' then Total else 0 end)) as STotal 
		from Inventario a 
			inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
			inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
			left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
			left join TIPDOC g on g.Cd_TD=a.Cd_TD 
			inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMBse
			inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
			left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
			left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE
		where a.RucE = @RucE and a.FecMov between convert(nvarchar,@FecD,103) and Convert(nvarchar,@FecH,103)
	--	and a.Cd_Inv > Convert(nvarchar, isnull(@Ult_CdInv,''))
		group by a.Cd_Prod, d.Nombre1, d.Descrip
	) as inv 
) as totales

-- Pruebas:
-- exec Inv_InventarioCons_ExploGenTotales '11111111111', '01/01/2000','30/11/2050',null 
-- MM: Creacion del sp
GO

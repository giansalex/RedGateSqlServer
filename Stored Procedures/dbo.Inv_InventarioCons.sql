SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as
if not exists (select top 1 * from Inventario where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
else
	begin
select p2.Cd_TE, te.Nombre from producto2 p2  
 left join tipoexistencia te on te.Cd_TE=p2.Cd_TE
 where p2.Cd_Prod=@Cd_Prod and p2.RucE=@RucE

select a.Cd_Inv, a.RegCtb,a.Cd_Alm, e.Nombre as NombreAlm, a.Cd_Prod, d.Nombre1 as NombreProducto , d.Descrip, 
	 c.Nombre as UnidadMedida, convert(varchar, a.FecMov,103) as FecMov, a.Cd_TDES, a.Cd_TD, tp.Descrip as TipoDocumento,
	 a.Cd_TO, tpo.Nombre as TipoOperacion, a.NroSre, a.Ejer, b.Factor, b.DescripAlt,
	 case(a.IC_ES) when 'E' then 'Entrada' else 'Salida' end as IC_ES,
	 i.Descrip as Descrip2, Case(a.IC_ES) when 'E' then Convert(nvarchar,a.Cant) else '-' end as ECant ,
	 Case(a.IC_ES) when 'E' then Convert(nvarchar,a.CosUnt) else '-' end as ECosUnt,
	 Case(a.IC_ES) when 'E' then Convert(nvarchar,a.Total) else '-' end as ETotal,
	 Case(IC_ES) when 'S' then Convert(nvarchar,a.Cant) else '-' end as SCant ,
	 Case(a.IC_ES) when 'S' then Convert(nvarchar,a.CosUnt) else '-' end as SCosUnt,
	 Case(a.IC_ES) when 'S' then Convert(nvarchar,a.Total) else '-' end as STotal,
	 a.SCant as Suma_Cantidad, a.CProm, a.SCT, a.Cd_GR,a.NroGC,
	 a.CA01, a.CA02, a.CA03, a.CA04, a.CA05
	  from Inventario a 
		inner join Almacen e on e.Cd_Alm=a.Cd_Alm and e.RucE = a.RucE
		inner join Producto2 d on d.Cd_Prod=a.Cd_Prod and d.RucE = a.RucE
		left join TipDocES f on f.Cd_TDES=a.Cd_TDES and f.RucE = a.RucE
		left join TIPDOC g on g.Cd_TD=a.Cd_TD 
		inner join Prod_UM b on b.RucE=a.RucE and b.Cd_Prod=a.Cd_Prod and b.ID_UMP=a.ID_UMP
		inner join UnidadMedida c on c.Cd_UM=b.Cd_UM
		left join Area h on h.Cd_Area=a.Cd_Area and h.RucE=a.RucE
		left join MtvoIngSal i on i.Cd_MIS=a.Cd_MIS and a.RucE=i.RucE
		left join TipoOperacion tpo on tpo.Cd_TO=a.Cd_TO
		left join TipDoc tp on tp.Cd_TD = a.Cd_TD
	where a.RucE=@RucE and d.Cd_Prod=@Cd_Prod
	end
-- Leyenda --
-- JJ : 2010-07-02 15:13:13.633	: <Creacion del procedimiento almacenado>
-- JJ : 2010-07-05 15:14:45.323	: <Modificacion del procedimiento almacenado>
-- JJ : 2010-08-09 15:14:45	: <Modificacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VtaDetalleCons]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
/*if not exists (select top 1 * from VentaDet where RucE=@RucE)
	set @msj = 'Venta Detalle no existe'
else */	
	select a.Nro_RegVdt, a.Cd_Pro, b.Nombre,a.Cant,
		Case(d.IB_Anulado) when 1 then 0 else a.Valor end as Valor,
		Case(d.IB_Anulado) when 1 then 0 else a.DsctoP end as DsctoP,
		Case(d.IB_Anulado) when 1 then 0 else a.DsctoI end as DsctoI,
		Case(d.IB_Anulado) when 1 then 0 else a.IMP end as IMP,
		Case(d.IB_Anulado) when 1 then 0 else a.IGV end as IGV,
		Case(d.IB_Anulado) when 1 then 0 else a.Total end as Total  
	from VentaDet a
	inner join Producto b on b.RucE=a.RucE and b.Cd_Pro=a.Cd_Pro
	inner join Venta d on d.RucE=a.RucE and d.Cd_Vta=a.Cd_Vta
	where a.RucE=@RucE and a.Cd_Vta=@Cd_Vta 
print @msj
--PV
GO

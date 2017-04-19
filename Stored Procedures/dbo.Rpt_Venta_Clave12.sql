SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_Clave12]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
As 

Select
	--INFO. DE FACTURA
	--**************************
	v.RucE,v.Cd_Vta,s.NroSerie,v.NroDoc,Case(v.Cd_Mda) when '01' then 'S/.' else 'US$.' end Moneda,	
	--INFO. DEL CLIENTE
	--*************************
	datename(day,v.FecMov)+' de '+datename(month,v.FecMov)+' del '+datename(year,v.FecMov) as FecMov,
	v.Cd_Clt,a.NDoc as RucCli,isnull(a.RSocial,a.ApPat+' '+a.ApMat+' '+a.Nom) as NomCli,a.Direc,v.Obs,
	--INF. TOTALES
	--*************************
	v.BIM as SubTotal, 0.00 as Dscto,v.IGV,v.EXO,v.Total
from Venta v
left join Serie s on v.RucE=s.RucE and v.Cd_Sr=s.Cd_Sr
--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Cte=a.Cd_Aux
left join Cliente2 a on v.RucE=a.RucE and v.Cd_Clt=a.Cd_Clt
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta

Select 
	--INF. DETALLE DE LA FACTURA
	--*************************
	/*d.Cd_Pro*/d.Cd_Prod,p.Nombre1,Case(v.Cd_Mda) when '01' then 'S/. '+Convert(varchar,d.IMP) else 'US$. '+Convert(varchar,d.IMP) end IMP
from Venta v
left join VentaDet d on v.RucE=d.RucE and v.Cd_Vta=d.Cd_Vta
--left join Producto p on d.RucE=p.RucE and d.Cd_Pro=p.Cd_Pro
left join Producto2 p on d.RucE=p.RucE and d.Cd_Prod=p.Cd_Prod
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta

/*MP: LUN 20-09-2010 Modf: Se quito las referencias a la tabla Auxiliar y se enlazo con Cliente2, ademas se reemplazo
Produco por Producto2*/
GO

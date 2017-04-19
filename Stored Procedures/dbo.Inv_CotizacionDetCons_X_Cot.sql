SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetCons_X_Cot]

/*
exec Inv_CotizacionConsUn '11111111111','CT00000002',null
*/

@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output

as
/*
if not exists (select * from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe detalle cotizacion'
else
*/
begin
	select	
		c.Cd_Cot,
		c.ID_CtD,	
		--c.Cd_Prod,
		case(isnull(c.Cd_Prod,'0')) when '0' then case(isnull(c.Cd_Srv,'0')) when '0' then null else c.Cd_Srv end else c.Cd_Prod end as Codigo,
		c.Descrip,
		isnull(c.CU,0.00) as CU,
		m.NCorto as UM,
		1.000 As Factor,--u.Factor
		isnull(c.Cant,0.000) as Cant,
		isnull(c.Costo,0.00) as Costo,
		isnull(c.PU,0.00) as PU,
		isnull(c.Valor,0.00) as Valor,
		Convert(decimal(13,2),isnull(c.DsctoI,0.00)/isnull(c.Cant,0.00)) as DsctoxUni,
		isnull(c.DsctoI,0.00) as DsctoI,
		isnull(c.DsctoP,0.00) as DsctoP,
		isnull(c.BIM,0.00) as BIM,
		case(isnull(len(c.Cd_Prod),'0')) when '0' then case(isnull(len(c.Cd_Srv),'0')) when '0' then Case(isnull(c.IGV,0.00)) when 0.00 then 0 else 1 end else p2.IB_IncIGV end else p1.IB_IncIGV end as IncIgv,
		isnull(c.IGV,0.00) as IGV,
		isnull(c.Total,0.00) as Total,
		isnull(c.MU_Imp,0.00) as MU_Imp,
		isnull(c.MU_Porc,0.00) as MU_Porc,
		c.Cd_CC,
		c.Cd_SC,
		c.Cd_SS
	from CotizacionDet c 
	left join Prod_UM u On u.RucE=c.RucE and u.Cd_Prod=c.Cd_Prod and u.ID_UMP=c.ID_UMP
	left join UnidadMedida m On m.Cd_UM=u.Cd_UM
	left join Precio p1 On p1.RucE=c.RucE and p1.Cd_Prod=c.Cd_Prod and p1.ID_Prec=c.ID_Prec
	left join PrecioSrv p2 On p2.RucE=c.RucE and p2.Cd_Srv=c.Cd_Srv and p2.ID_PrSv=c.ID_PrSv
	where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
GO

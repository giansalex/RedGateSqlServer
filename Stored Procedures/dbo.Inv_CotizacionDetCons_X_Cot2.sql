SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetCons_X_Cot2]

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
		c.*,
		--m.NCorto as UndMed
		u.DescripAlt as UndMed
	from CotizacionDet c 
	left join Prod_UM u On u.RucE=c.RucE and u.Cd_Prod=c.Cd_Prod and u.ID_UMP=c.ID_UMP
	left join UnidadMedida m On m.Cd_UM=u.Cd_UM
	where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot
end

-- Leyenda --
-- DI : 07/06/2011 : <Creacion del procedimiento almacenado>
GO

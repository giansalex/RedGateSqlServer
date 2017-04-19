SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Vta_GuiaRemisionDet_Cons_paVta1]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as

if not exists (select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR and IC_ES = 'S')
	Set @msj = 'No existe Guia de Remisión'
else
begin
	select o.Cd_Prod, pd.Nombre1 as Descrip, o.ID_UMP, o.Cant, pu.DescripAlt as UMP_, pd.CodCo1_
	from GuiaRemisionDet o
		left join Prod_UM pu on o.RucE = pu.RucE and o.Cd_Prod = pu.Cd_Prod and o.ID_UMP = pu.ID_UMP
		left join Producto2 pd on pd.Cd_Prod = o.Cd_Prod and pd.RucE = o.RucE and pd.RucE = pu.RucE and pd.Cd_Prod = pu.Cd_Prod 
	where o.RucE = @RucE and o.Cd_GR = @Cd_GR
	set @msj = ''
end

-- LEYENDA
-- exec user321.Vta_GuiaRemisionDet_Cons_paVta '11111111111','GR00000277',null
/*
select * from Producto2 where RucE = '11111111111'
--MP: 14/06/2012 : <Modificacion del procedimiento almacenado>
*/
GO

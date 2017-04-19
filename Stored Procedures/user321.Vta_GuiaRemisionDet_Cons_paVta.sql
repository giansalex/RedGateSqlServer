SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Vta_GuiaRemisionDet_Cons_paVta]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as

if not exists (select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR and IC_ES = 'S')
	Set @msj = 'No existe Guia de Remisión'
else
begin
	select o.Cd_Prod, o.Descrip, o.ID_UMP, o.Cant, pu.DescripAlt as UMP_
	from GuiaRemisionDet o
		left join Prod_UM pu on o.RucE = pu.RucE and o.Cd_Prod = pu.Cd_Prod and o.ID_UMP = pu.ID_UMP
	where o.RucE = @RucE and o.Cd_GR = @Cd_GR
	set @msj = ''
end

-- LEYENDA
-- exec user321.Vta_GuiaRemisionDet_Cons_paVta '11111111111','GR00000277',null
GO

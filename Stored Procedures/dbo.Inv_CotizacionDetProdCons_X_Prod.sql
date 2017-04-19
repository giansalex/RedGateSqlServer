SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetProdCons_X_Prod]

/*
exec Inv_CotizacionProdDetConsUn '11111111111','1',null
*/

@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
@msj varchar(100) output

as
begin
	select	
		Cd_Cot,ID_CtD,Item,Cpto,Valor
	from CotizacionProdDet 
	where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
GO

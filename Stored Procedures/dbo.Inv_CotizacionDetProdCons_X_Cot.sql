SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetProdCons_X_Cot]

@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output

as
begin
	select	
		Cd_Cot,ID_CtD,Item,Cpto,Valor
	from CotizacionProdDet 
	where RucE=@RucE and Cd_Cot=@Cd_Cot
end

-- Leyenda --
-- DI : 09/06/2011 : <Creacion del procedimiento almacenado>
GO

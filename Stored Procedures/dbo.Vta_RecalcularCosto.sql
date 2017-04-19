SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_RecalcularCosto] 
@Ruce char(11), 
@Cd_Vta char(10), 
@msj nchar(100) output
as
update VentaDet
	set 
	Costo = - isnull((select sum(Total) from Inventario where RucE = @RucE and Cd_Vta = @Cd_Vta and Item = VentaDet.Nro_RegVdt),0),
	Costo_ME = - isnull((select sum(Total_ME) from Inventario where RucE = @RucE and Cd_Vta = @Cd_Vta and Item = VentaDet.Nro_RegVdt),0)
	where RucE  = @RucE and Cd_Vta = @Cd_Vta
	
update VentaDet
	set CU = (Costo / Cant),
	CU_ME =  (Costo_ME / Cant)
	where RucE  = @RucE and Cd_Vta = @Cd_Vta
GO

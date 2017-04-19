SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[CalcularPendienteGRxINV](@RucE nvarchar(11),@Cd_GR char(10))
returns numeric(15,9) AS
begin
		declare @pendiente numeric (15,9)
		select @pendiente =  c.Cant-ABS(isnull((select sum(Cant_Ing) 
			from Inventario i 
			where i.RucE = c.RucE and i.Cd_GR = c.Cd_GR and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0 )) 
			from GuiaRemisionDet c where c.RucE = @RucE and c.Cd_GR = @Cd_GR and c.Cd_Prod is not null
		return @pendiente
		
-- select * from GuiaRemision where RucE = '11111111111' and Cd_GR = 'GR00000292'
end
-- CAM 22/05/2012 creacion
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_LiquidacionFondoConsFechaCierre]
@RucE nvarchar(11),
@Cd_Liq char(10),
@msj varchar(100) output
as
if not exists (select  Cd_Liq from Liquidacion where Cd_Liq=@Cd_Liq and RucE = @RucE)
	set @msj = 'Liquidacion de Fondo no existe'
else	
	select RucE,Cd_Liq,FechaCierre
	from Liquidacion
	WHERE RucE = @RucE and Cd_Liq=@Cd_Liq
	
print @msj
GO

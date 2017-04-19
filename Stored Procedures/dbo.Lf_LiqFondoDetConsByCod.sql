SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_LiqFondoDetConsByCod]
@RucE NVARCHAR(11),
@Cd_Liq CHAR(10),
@msj varchar(100) OUTPUT
as
if not exists (SELECT * FROM dbo.LiquidacionDet ld WHERE ld.RucE=@RucE AND ld.Cd_Liq=@Cd_Liq)
BEGIN
	SET @msj = 'No existe liquidacion detalle'
END
ELSE
BEGIN
	SELECT * FROM dbo.LiquidacionDet ld WHERE ld.RucE=@RucE AND ld.Cd_Liq=@Cd_Liq
END


--LEYENDA
--FECHA : 04/03/2013
--CREADO: ERIC SOLANO LEVANO
--PRUEBAS : EXEC Lf_LiqFondoDetConsByCod '11111111111','LF00000001',''
GO

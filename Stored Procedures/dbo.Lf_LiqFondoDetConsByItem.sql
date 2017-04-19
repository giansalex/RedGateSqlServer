SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[Lf_LiqFondoDetConsByItem]
@RucE NVARCHAR(11),
@Cd_Liq CHAR(10),
@Item int,
@msj varchar(100) OUTPUT
as
if not exists (SELECT * FROM dbo.LiquidacionDet ld WHERE ld.RucE=@RucE AND ld.Cd_Liq=@Cd_Liq AND ld.Item=@Item)
BEGIN
	SET @msj = 'No existe liquidacion detalle por item.'
END
ELSE
BEGIN
	SELECT * FROM dbo.LiquidacionDet ld WHERE ld.RucE=@RucE AND ld.Cd_Liq=@Cd_Liq AND ld.Item= @Item
END


--LEYENDA
--FECHA : 05/03/2013
--CREADO: ERIC SOLANO LEVANO
--PRUEBAS : EXEC Lf_LiqFondoDetConsByCod '11111111111','LF00000001',''
GO

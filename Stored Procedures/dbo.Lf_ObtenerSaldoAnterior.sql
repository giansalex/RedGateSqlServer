SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Lf_ObtenerSaldoAnterior]
@RucE nvarchar(11),
@SaldoAnterior numeric (18,3) output,
@msj VARCHAR(100) OUTPUT
AS
declare @c varchar(15)
select @c = count(Cd_Liq) from Liquidacion where RucE=@RucE
print @c
If(@c > 0)
	Begin	
		--OBTENEMOS EL MAXIMO
		DECLARE  @Cd_Liq char(10)
		SELECT @Cd_Liq =  MAX(Cd_Liq)
		FROM Liquidacion l WHERE l.RucE=@RucE
		print @Cd_Liq
		
		SELECT @SaldoAnterior = convert(varchar(18),(l.MtoAper-Sum(ld.Total))) FROM Liquidacion l INNER JOIN LiquidacionDet ld ON l.RucE = ld.RucE AND l.Cd_Liq = ld.Cd_Liq
		WHERE l.RucE = @RucE AND ld.Cd_Liq=@Cd_Liq
		GROUP BY l.MtoAper
		
	end
Else
	Begin
		set @SaldoAnterior = 0.000
	End

--LEYENDA
--CREADO : 05/03/2013
--PRUEBAS : EXEC Lf_ObtenerSaldoAnterior '11111111111',null,''
GO

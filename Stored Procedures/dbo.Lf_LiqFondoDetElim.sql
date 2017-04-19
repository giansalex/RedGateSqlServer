SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lf_LiqFondoDetElim]

@RucE nvarchar(11),
@Cd_Liq char(10),
@Item  int,
@msj varchar(100) output
as
if not exists (select Cd_Liq, Item from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cd_Liq and Item = @Item)
	set @msj = 'Liquidacion de Fondo no existe'
else
begin
	begin transaction
	delete LiquidacionDet where RucE=@RucE and Cd_Liq=@Cd_Liq and Item=@Item
	if @@rowcount <= 0
		set @msj = 'Liquidacion de Fondo no pudo ser eliminado'
	commit transaction
end
print @msj

--Leyenda 

--BG : 28/02/2013 <se creo SP>
GO

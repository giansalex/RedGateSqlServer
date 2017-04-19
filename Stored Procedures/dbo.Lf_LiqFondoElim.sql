SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoElim]

@RucE nvarchar(11),
@Cd_Liq char(10),
@RegCtb  nvarchar(15),
@msj varchar(100) output
as
if not exists (select Cd_Liq from Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq and RegCtb = @RegCtb)
	set @msj = 'Liquidacion de Fondo no existe'
else
begin
	begin transaction
	delete Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq and RegCtb = @RegCtb
	if @@rowcount <= 0
		set @msj = 'Liquidacion de Fondo no pudo ser eliminado'
	commit transaction
end
print @msj

--Leyenda 

--BG : 28/02/2013 <se creo SP>
GO

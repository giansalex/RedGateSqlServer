SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioMdf]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@Ejer nvarchar(4),
@Cd_Inv char(12),
--
@IC_ES char(1),
@ID_UMP int,
@Cd_Prod char(7),
@Cant_Ing numeric(13,3),
@Cant numeric(13,3),
@CosUnt numeric(13,2),
@Total numeric(13,2),
@msj varchar(100) output
as 

if not exists (select * from Inventario WHERE RucE = @RucE and Ejer=@Ejer and RegCtb = @RegCtb and Cd_Inv = @Cd_Inv)
	set @msj = 'No existe el Movimiento de Inventario.'
else
begin

	set @Cant = (select Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP)*@Cant_Ing
	
	if (@IC_ES = 'S')
	begin
		set @Cant_Ing = 0-@Cant_Ing
		set @Cant = 0-@Cant
		set @Total = 0-@total
	end
	
	update Inventario set 
	Cant_Ing = @Cant_Ing,
	Cant = @Cant,--
	CosUnt = @CosUnt, 
	Total = @Total,
	CosUnt_ME = @CosUnt / CamMda, 
	Total_ME = @Total / CamMda
	WHERE RucE = @RucE and Ejer=@Ejer and RegCtb = @RegCtb and Cd_Inv = @Cd_Inv

end

--LEYENDA
--CAM 04/07/2011 <Creacion de SP>

/*
select * from Inventario where RucE = '11111111111' 
and Ejer = '2011' and RegCtb = 'INGE_LD07-00014'
*/
GO

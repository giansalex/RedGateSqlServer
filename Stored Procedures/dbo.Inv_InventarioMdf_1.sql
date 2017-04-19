SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioMdf_1]
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
@UsuMdf varchar(10),
@FecMdf datetime,
@msj varchar(100) output
as 
-- El Usuario j.garrido de la Empresa MER no debe poder eliminar ni modificar Mov de Inventario segun correo con fecha miércoles 14/09/2011 08:44 a.m. - Melissa Rojas [melissar@mer-peru.com]
------------
if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2)) = 1)
	set @msj = 'Inventario no se puede Modificar, el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no se encuentra habilitado'
------------
else if(@UsuMdf = 'j.garrido' and @RucE = '20512141022')
	set @msj = 'El usuario no tiene permiso para modificar inventario.'
else
begin
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
		CosUnt = @CosUnt/(select Factor from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP), 
		Total = @Total,
		CosUnt_ME = @CosUnt / CamMda, 
		Total_ME = @Total / CamMda,
		UsuModf = @UsuMdf,
		FecMdf = @FecMdf
		WHERE RucE = @RucE and Ejer=@Ejer and RegCtb = @RegCtb and Cd_Inv = @Cd_Inv

	end
end

--LEYENDA
-- CAM 04/07/2011 <Creacion de SP>
-- CAM 14/09/2011 <Modificacion del SP - Se agrego UsuMdf y FecMdf>
-- CE: 20/08/2012 Mdf: Antes de Elim/crear/Modf verificar si el periodo esta habilitado en el cierre de periodo

/*
select * from Inventario where RucE = '11111111111' and Ejer = '2011' and RegCtb = 'INGE_LD07-00014'
*/
GO

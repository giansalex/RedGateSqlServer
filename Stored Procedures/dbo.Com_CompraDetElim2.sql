SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_CompraDetElim2]
@RucE nvarchar (11),
@Cd_Com char (10),
@msj varchar(100) output
as
begin
if(User123.VPrdo(@RucE,(select Ejer from compra where ruce=@RucE and Cd_Com=@Cd_Com),SubString((select RegCtb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2)) = 1)
	set @msj = 'El Detalle de Compra no se puede eliminar, el periodo '+User123.DamePeriodo(SubString((select RegCtb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2))+' no se encuentra habilitado'
else
begin
	begin transaction
		if exists (select * from CompraDet where RucE =@RucE and Cd_Com = @Cd_Com)
		begin

			delete from CompraDet where RucE =@RucE and Cd_Com = @Cd_Com
			if @@rowcount  <= 0
			begin 
				set @msj = 'Error al eliminar Compra Detalle'
				rollback transaction
				return
			end 

		end
	commit transaction
end
end
-- Leyenda --
-- JJ : 2010-08-23 : <Creacion del procedimiento almacenado>
-- MP : 2010-11-25 : <Modificacion del procedimiento almacenado> 
--CE: 20/08/2012 Mdf: Antes de Elim/crear/Modf verificar si el periodo esta habilitado en el cierre de periodo



GO

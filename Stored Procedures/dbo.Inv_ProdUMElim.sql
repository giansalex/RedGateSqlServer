SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMElim]
@RucE nvarchar(11),
@Cd_Prod char(7),
@ID_UMP int,
@msj varchar(100) output
as
if not exists (select * from Prod_UM where  RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP)
	set @msj = 'Unidad de medida de producto no existe'
else
	begin
		begin transaction
		if exists(select * from cotizaciondet where Id_Prec in (select Id_Prec from precio where  RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP) and RucE = @RucE and Cd_Prod = @Cd_Prod)
			set @msj = 'Unidad de Medida no puede ser eliminado, ver cotizaciones relacionadas'
		else
			begin
				if exists(select * from cotizaciondet where ID_UMP in (select ID_UMP  from Prod_UM where  RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP) and RucE = @RucE  and Cd_Prod = @Cd_Prod)
					set @msj = 'Unidad de Medida no puede ser eliminado, ver cotizaciones relacionadas'
				else 	
					begin
						delete preciohist where Id_Prec in (select Id_Prec from precio where  RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP) and RucE = @RucE 
						delete from precio where  RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP
						delete from Prod_UM where RucE = @RucE and Cd_Prod =@Cd_Prod and ID_UMP=@ID_UMP
						if @@rowcount <= 0
							begin								set @msj = 'Unidad de medida de producto no pudo ser eliminado'
								rollback transaction
							end	
					end
			end
		commit transaction	
	end
print @msj
-- Leyenda --
-- PP : 2010-02-24 		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-20 12:56:25.690	: <Modifacion del procedimiento almacenado por la eliminacion en CASCADA>


GO

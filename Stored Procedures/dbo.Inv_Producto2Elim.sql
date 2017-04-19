SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Elim]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as
if not exists (select * from Producto2 where  RucE = @RucE and Cd_Prod=@Cd_Prod)
	set @msj = 'Producto no existe'
else
begin
	if exists(select * from cotizaciondet where RucE = @RucE and Cd_Prod=@Cd_Prod)
		set @msj = 'Producto no puede ser eliminado debido a que tiene cotizaciones relacionadas'
	else 
		begin
			begin transaction
			delete preciohist where RucE = @RucE and  Id_Prec in (select Id_Prec from precio where Cd_Prod=@Cd_Prod and RucE = @RucE)
			delete from precio where RucE = @RucE and Cd_Prod=@Cd_Prod
			delete from Prod_UM where RucE = @RucE and Cd_Prod=@Cd_Prod
			delete from ProdSustituto where RucE = @RucE and (Cd_ProdB=@Cd_Prod or Cd_ProdS=@Cd_Prod)
			delete from Producto2 where RucE = @RucE and Cd_Prod=@Cd_Prod
			if @@rowcount <= 0
			begin				set @msj = 'Producto no pudo ser eliminado'
				rollback transaction
			end
			commit transaction
		end
end
print @msj

select * from preciohist
-- Leyenda --
-- PP : 2010-02-23 		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-20 12:27:24.173	: <Modifacion del procedimiento almacenado por la eliminacion en CASCADA>





GO

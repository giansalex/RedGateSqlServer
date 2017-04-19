SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdComboElimxProdB]
@RucE nvarchar(11),
@Cd_ProdB char(7),
@msj varchar(100) output

as

if not exists (select * from Producto2 where  RucE = @RucE and Cd_Prod=@Cd_ProdB)
	set @msj = 'Producto no existe'
else
begin
	begin transaction
	delete from ProdCombo where RucE = @RucE and Cd_ProdB = @Cd_ProdB
	
	if @@rowcount <= 0
	begin		set @msj = 'Los Productos no pudieron ser eliminados'
		rollback transaction
	end
	commit transaction
end
print @msj


--MP: 2011-02-28 : <Creacion del Procedimiento Almacenado>
--Example
--select * from ProdCombo where RucE = '11111111111' and Cd_ProdB = 'PD00001'

GO

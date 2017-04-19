SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MarcaElim]
@RucE nvarchar(11),
@Cd_Mca char(3),
@msj varchar(100) output
as
if not exists (select * from Marca where RucE = @rucE and Cd_Mca=@Cd_Mca)
	set @msj = 'Marca ' + @Cd_Mca + ' no existe.'
else
begin
	delete from Marca where RucE = @rucE and Cd_Mca=@Cd_Mca 
	
	if @@rowcount <= 0
	set @msj = 'Marca  ' + @Cd_Mca + ' no pudo ser eliminado.'	
end
print @msj

GO

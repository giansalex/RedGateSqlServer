SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_DirecTransCons_X_Trans]
@RucE nvarchar(11),
@Cd_Tra char(10),
@msj varchar(100) output
as
begin
	if not exists (select * from DirecTrans where RucE=@RucE and Cd_Tra = @Cd_Tra)
	set @msj = 'No hay direccion para ese transportista'
	else
	select Direc, Obs from DirecTrans where RucE = @RucE and Cd_Tra = @Cd_Tra and Estado = 1
end
print @msj

--set @Direc = 'mi direccion'
-- Leyenda --
-- FL : 2011-03-10 <se creo proc para consultar dir de transportistas>





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_DirecEntCons_X_Clt]
@RucE nvarchar(11),
@Cd_Clt char(10),
--@Direc varchar(100) output,
@msj varchar(100) output
as
begin
	if not exists (select * from DirecEnt where RucE=@RucE and Cd_Clt = @Cd_Clt)
	set @msj = 'No hay direccion para ese cliente'
	else
	select Direc, Obs from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt and Estado = 1
end
print @msj
--print @Direc

--set @Direc = 'mi direccion'
-- Leyenda --
-- FL : 2010-10-26 <se creo proc para consultar dir de clientes>

-- PV



GO

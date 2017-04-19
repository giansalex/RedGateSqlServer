SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Inv_Lote_EliminaUn]
@RucE nvarchar(11),
@Cd_Lote char(10),
@msj varchar(100) output
as
if not exists (select * from lote where RucE=@RucE and Cd_Lote=@Cd_Lote)
 set @msj='No Existe Lote Seleccionado'
else
begin
	if not exists(select * from productoxlote where RucE=@RucE and Cd_Lote=@Cd_Lote)
		delete from lote  where RucE=@RucE and Cd_Lote=@Cd_Lote
	else 
		set @msj='El Lote no pudo ser Eliminado porque tiene Productos dentro'
end 
print @msj

-- Leyenda 
-- Leo 01/03/2013 <Creacion>
GO

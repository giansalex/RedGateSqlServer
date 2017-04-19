SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[Inv_Lote_EliminaConProductos]
@RucE nvarchar(11),
@Cd_Lote char(10),
@msj varchar(100) output
as
if not exists (select * from lote where RucE=@RucE and Cd_Lote=@Cd_Lote)
 set @msj='No Existe Lote seleccionado.'
else
begin
	delete from ProductoxLote where RucE=@RucE and Cd_Lote=@Cd_Lote
	delete from lote  where RucE=@RucE and Cd_Lote=@Cd_Lote

end 
print @msj

-- Leyenda 
-- Cam 21/03/2013 <Creacion>
GO

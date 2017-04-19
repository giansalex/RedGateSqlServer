SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_CptoCostoOFElim]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
if not exists (select * from CptoCostoOF where RucE=@RucE and Cd_OF=@Cd_OF)
	set @msj = 'Concepto de Costo de la Orden de Fabricacion No Existe'
else
begin
	delete from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF
	delete from CptoCostoOF where RucE=@RucE and Cd_OF=@Cd_OF
end
print @msj

-- Leyenda --
-- FL : 2011-03-09 : <Creacion del procedimiento almacenado>
GO

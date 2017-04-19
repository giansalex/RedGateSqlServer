SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[Pre_MontoPresu_Elim]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@msj varchar(100) output

as
if exists (select * from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
begin
	delete from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta
	if @@rowcount <= 0
		Set @msj ='Error al restaurar valores'
end

-- Leyedan --
-- DI : 11/01/10 <Creacion del procedimiento almacenado>

GO

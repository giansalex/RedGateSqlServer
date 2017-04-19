SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Servicio2Cons_paCtSxGr] --Consulta de Servicios x Grupo para Cartera de Servicios
@RucE nvarchar(11),
@Cd_GS varchar(6),
@msj varchar(100) output
as
/*declare @check bit
set @check=0*/
begin
	select /*@check as Sel,*/Cd_Srv as Codigo,Nombre
	from Servicio2 
	where RucE = @RucE and Cd_GS=@Cd_GS
end
	
print @msj
-- Leyenda --
-- J : 2010-03-24 : <Creacion del procedimiento almacenado>

GO

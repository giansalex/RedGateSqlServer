SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_AlmaConsTodos]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin	
	if(@TipCons=3)
		begin			
			select a1.Cd_Alm,a1.Nombre
			from Almacen a1
			where RucE=@RucE and Estado = 1
			order by a1.Cd_Alm				
		end
end
print @msj

-- Leyenda --
-- ESL : 24/01/2013 : <Creacion del procedimiento almacenado>

GO

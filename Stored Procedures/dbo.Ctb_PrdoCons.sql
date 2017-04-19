SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PrdoCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
/*if not exists (select top 1 * from Periodo where RucE=@RucE)
	set @msj = 'No se encontro Ejercicio'
else*/	select Ejer from Periodo where RucE=@RucE order by Ejer desc
print @msj
GO

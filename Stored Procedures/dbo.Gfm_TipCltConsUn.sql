SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipCltConsUn](
	@Cd_TClt char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
as
if not exists(select * from TipClt where Cd_TClt = @Cd_TClt and RucE = @RucE)
	set @msj = 'Tipo de proveedor no existe'+@Cd_TClt
else
	select * from TipClt where Cd_TClt = @Cd_TClt and RucE = @RucE
print @msj
--Leyenda
--JV : 13/07/2011 : <Creación de procedimiento almacenado.>
--JV : 20/07/2011 : <Modificación - Se agrega parámetro de RucE.>
GO

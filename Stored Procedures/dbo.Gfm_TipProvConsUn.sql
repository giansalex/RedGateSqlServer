SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipProvConsUn](
	@Cd_TPrv char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
as
if not exists(select * from TipProv where Cd_TPrv = @Cd_TPrv and RucE = @RucE)
	set @msj = 'Tipo de proveedor no existe'+@Cd_TPrv
else
	select * from TipProv where Cd_TPrv = @Cd_TPrv and RucE = @RucE
print @msj
--Leyenda
--JV : 09/07/2011 : <Creación de procedimiento almacenado.>
GO

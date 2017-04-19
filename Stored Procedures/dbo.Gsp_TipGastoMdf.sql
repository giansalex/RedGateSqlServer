SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipGastoMdf]
@Cd_TG nvarchar(2),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipGasto where Cd_TG=@Cd_TG)
	set @msj = 'No existe Tipo Gasto'
else
begin
	update TipGasto set Nombre=@Nombre, Estado=@Estado
	where Cd_TG=@Cd_TG

	if @@rowcount <= 0
		set @msj = 'Tipo Gasto no pudo ser modificado'
end
print @msj
-- DI 13/02/2009
GO

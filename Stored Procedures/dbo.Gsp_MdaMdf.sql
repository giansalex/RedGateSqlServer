SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_MdaMdf]
@Cd_Mda nvarchar(2),
@Nombre varchar(50),
@Simbolo varchar(6),
@Estado bit,
@msj varchar(100) output
as

if not exists (select * from Moneda where @Cd_Mda=@Cd_Mda)
	set @msj = 'Moneda no existe'
else
begin
	update Moneda set Nombre=@Nombre, Simbolo=@Simbolo, Estado=@Estado
	where Cd_Mda=@Cd_Mda
	
	if @@rowcount <= 0
	   set @msj = 'Moneda no pudo ser modificado'
end
print @msj
GO

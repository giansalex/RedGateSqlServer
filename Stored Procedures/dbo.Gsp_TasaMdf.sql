SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaMdf]
@Cd_Ts nvarchar(3),
@Nombre varchar(50),
@NCorto nvarchar(5),
@Tasa numeric(5),
--@Cta nvarchar(10),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Tasas where Cd_Ts=@Cd_Ts)
	set @msj = 'Tasa no existe'
else
begin
	update Tasas set Nombre=@Nombre, NCorto=@NCorto, Tasa=@Tasa, Estado=@Estado
	where Cd_Ts=@Cd_Ts
	
	if @@rowcount <= 0
	   set @msj = 'Tasa no pudo ser modificado'
end
print @msj
GO

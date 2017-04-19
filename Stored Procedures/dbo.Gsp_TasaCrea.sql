SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaCrea]
--@Cd_Ts nvarchar(3),
@Nombre varchar(50),
@NCorto nvarchar(5),
@Tasa numeric(5),
--@Cta nvarchar(10),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from Tasas where Nombre=@Nombre)
	set @msj = 'Existe una tasa con la misma cuenta'
else
begin
	insert into Tasas(Cd_Ts,Nombre,NCorto,Tasa,Estado)
		   values(user123.Cod_Ts(),@Nombre,@NCorto,@Tasa,1)
	
	if @@rowcount <= 0
	   set @msj = 'Tasa no pudo ser registrado'
end
print @msj
GO

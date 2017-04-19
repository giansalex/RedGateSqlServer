SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_PaisCrea]
@Cd_Pais nvarchar(4),
@Nombre varchar(50),
@Siglas varchar(5),
@Estado bit,
@msj varchar(100) output
as

if exists (select * from Pais where Nombre=@Nombre)
	set @msj = 'Ya existe Pais con este nombre'
else
begin
	insert into Pais(Cd_Pais,Nombre,Siglas,Estado)
		    values(@Cd_Pais,@Nombre,@Siglas,1)
	
	if @@rowcount <= 0
	   set @msj = 'Pais no pudo ser creado'
end
print @msj
--bg 25/02/2013 : sp crea pais PD: gracias pepe
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_MdaCrea]
--@Cd_Mda nvarchar(2),
@Nombre varchar(50),
@Simbolo varchar(6),
--@Estado bit,
@msj varchar(100) output
as

if exists (select * from Moneda where Nombre=@Nombre)
	set @msj = 'Ya existe moneda con este nombre'
else
begin
	insert into Moneda(Cd_Mda,Nombre,Simbolo,Estado)
		    values(user123.Cod_Mda(),@Nombre,@Simbolo,1)
	
	if @@rowcount <= 0
	   set @msj = 'Moneda no pudo ser creado'
end
print @msj
GO

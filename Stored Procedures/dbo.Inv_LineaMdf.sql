SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_LineaMdf]
@Cd_Ln nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Linea where Cd_Ln=@Cd_Ln)
	set @msj = 'Linea no existe'
else
begin
	update Linea set Nombre=@Nombre, NCorto=@NCorto, 
                         Estado=@Estado
	where Cd_Ln=@Cd_Ln
	
	if @@rowcount <= 0
	set @msj = 'Linea no pudo ser modificado'	
end
print @msj
GO

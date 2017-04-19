SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_PaisMdf]
@Cd_Pais nvarchar(4),
@Nombre varchar(50),
@Siglas varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Pais where Cd_Pais=@Cd_Pais)
	set @msj = 'Pais no existe'
else
begin
	update Pais set Nombre = @Nombre, Siglas = @Siglas, Estado=@Estado where Cd_Pais=@Cd_Pais
			
	if @@rowcount <= 0
		set @msj = 'Pais no pudo ser modificado'
end

--bg 26/02/2013: sp modifica
GO

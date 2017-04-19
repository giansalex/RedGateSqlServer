SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ContactoConsUn]
@ID_Gen int,
@msj varchar(100) output
as
if not exists (select * from Contacto where ID_Gen =@ID_Gen)
	set @msj = 'Contacto no existe'
else
	select * from Contacto where ID_Gen =@ID_Gen
print @msj
-- Leyenda --
-- PP : 2010-02-17 : <Creacion del procedimiento almacenado>

GO

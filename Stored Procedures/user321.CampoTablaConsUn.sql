SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaConsUn]
@Id_CTb int,
@msj varchar(100) output
as

if not exists (select top 1 *from CampoTabla where Id_CTb=@Id_CTb)
	set @msj='No se encontro campo'
else 
Begin
	select 	con.Id_CTb,con.Cd_Tab,con.NomCol,con.NomDef,con.Estado
	from 	CampoTabla con
	where 	con.Id_CTb=@Id_CTb
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>


GO

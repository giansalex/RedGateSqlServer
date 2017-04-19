SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaMdf]
@Id_CTb int,
@Cd_Tab char(4),@NomCol varchar(100),
@NomDef varchar(100),@Estado bit,
@msj varchar(100) output
as

if not exists (select top 1 * from CampoTabla where Id_CTb=@Id_CTb)
	set @msj = 'Campo no existe'
update CampoTabla set Cd_Tab=@Cd_Tab, NomCol=@NomCol, NomDef=@NomDef, 
			Estado=@Estado 
		where 	Id_CTb=@Id_CTb
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>


GO

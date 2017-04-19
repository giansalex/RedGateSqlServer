SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaCrea]
@Id_CTb int out,
@Cd_Tab char(4),@NomCol varchar(100),
@NomDef varchar(100),@Estado bit,
@msj varchar(100) output
as

set @Id_CTb = dbo.Id_CTb()

if exists (select * from CampoTabla where Id_CTb=@Id_CTb)
	set @msj = 'Ya existe el campo'
else 
begin
insert 	into 	CampoTabla(Id_CTb,Cd_Tab,NomCol,NomDef,Estado)
	values	(@Id_CTb,@Cd_Tab,@NomCol,@NomDef,@Estado)
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>




GO

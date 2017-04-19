SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaCons]
@msj varchar(100) output
as
if not exists (select top 1 *from CampoTabla)
	set @msj='No se encontro campos'
else
begin
	select 	con.Id_CTb,con.Cd_Tab,con.NomCol,con.NomDef,con.Estado
	from 	CampoTabla con
end
-- Leyenda --
-- MP : 2010-12-30 : <Creacion del procedimiento almacenado>


GO

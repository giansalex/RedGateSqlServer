SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[CampoTablaConsxTabla]
@Cd_Tab char(4),
@msj varchar(100) output
as

--if not exists (select top 1 *from CampoTabla where Cd_Tab=@Cd_Tab)
--	set @msj='No se encontro campos'
--else 
--Begin
	select 	con.Id_CTb,con.Cd_Tab,con.NomCol,con.NomDef,con.Estado
	from 	CampoTabla con
	where 	con.Cd_Tab=@Cd_Tab
--end
-- Leyenda --
-- MP : 2011-07-25 : <Creacion del procedimiento almacenado>


GO

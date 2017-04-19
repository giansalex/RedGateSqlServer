SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_TablasxCamposHabilitados]
@prefijoTabla char(2),
@msj varchar(100) output
as


select * from Tabla 
where Cd_Tab in (select distinct Cd_Tab from CampoTabla where Estado = 1) 
	and LEFT(Cd_Tab, 2) = @prefijoTabla


--MP : 23-02-2011 : <Creacion del procedimiento almacenado>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioCons_paraDet]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output

AS

begin
	Select 
		Cd_CPtr,Cd_CPtr As Codigo,Nombre
	From ReportePatrimonio where RucE=@RucE and Ejer=@Ejer
end

-- Leyenda --
-- DI : 30/11/2012 <Creacion del SP>

GO

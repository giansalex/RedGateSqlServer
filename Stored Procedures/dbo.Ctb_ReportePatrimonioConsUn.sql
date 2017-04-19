SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtr nvarchar(5),
@msj varchar(100) output

AS

begin
	Select 
		RucE,Ejer,Cd_CPtr,Nombre,NCorto,Estado 
	From ReportePatrimonio where RucE=@RucE and Ejer=@Ejer and Cd_CPtr=@Cd_CPtr
end

-- Leyenda --
-- DI : 30/11/2012 <Creacion del SP>

GO

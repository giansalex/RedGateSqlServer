SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioDetConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtrD nvarchar(5),
@msj varchar(100) output

AS

begin
	Select 
		RucE,Ejer,Cd_CPtrD,Nombre,Cd_CPtr,NroCta,IB_esTitulo,Formula,Estado
	From ReportePatrimonioDet where RucE=@RucE and Ejer=@Ejer and Cd_CPtrD=@Cd_CPtrD
end

-- Leyenda --
-- DI : 05/12/2012 <Creacion del SP>

GO

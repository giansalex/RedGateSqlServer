SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroCons]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output		

AS

begin
	Select *,Cd_REF+' - '+Nombre As CodNom From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@msj varchar(100) output		

AS

begin
	Select * From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO

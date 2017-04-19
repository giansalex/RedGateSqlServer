SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroDetConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@Cd_Rub nvarchar(5),

@msj varchar(100) output		

AS

begin
	
	Select * From ReporteFinancieroDet
	Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF and Cd_Rub=@Cd_Rub
end
-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroDetCons_CodRub]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),

@Cd_Rub nvarchar(5) output,
@msj varchar(100) output		

AS

begin
	Select @Cd_Rub = 'R'+right('0000'+ltrim(Convert(int,right(isnull(Max(Cd_Rub),0),4))+1),4) From ReporteFinancieroDet 
	Where RucE=@RucE and Ejer=Ejer and Cd_REF=@Cd_REF
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO

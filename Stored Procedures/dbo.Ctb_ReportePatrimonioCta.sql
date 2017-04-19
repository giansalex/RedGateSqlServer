SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_ReportePatrimonioCta]

@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output

as

begin
	select NroCta,NroCta,NomCta from PlanCtas where RucE=@RucE and Estado=1 and Ejer=@Ejer
end

-- Leyenda --
-- DI : 28/12/2012 <Creacion del SP>

GO

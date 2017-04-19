SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroCons_PlanCtas]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@msj varchar(100) output		

AS

Select 
	REF01,
	REF02,
	REF03,
	REF04,
	REF05,
	REF06,
	REF07,
	REF08,
	REF09,
	REF10
From 
	PlanCtas
Where 
	RucE=@RucE
	and Ejer=@Ejer
	and NroCta=@NroCta

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO

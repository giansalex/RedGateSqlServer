SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroDetCons_CodREF]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@msj varchar(100) output

AS

Select 
	*
From 
	ReporteFinancieroDet 
Where 
	RucE=@RucE 
	and Ejer=@Ejer 
	and Cd_REF=@Cd_REF
	and isnull(IB_VerPlanCta,0)=1
Order by Cd_Rub
GO

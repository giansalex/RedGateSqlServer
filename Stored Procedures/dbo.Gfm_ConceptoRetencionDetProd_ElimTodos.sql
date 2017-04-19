SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_ConceptoRetencionDetProd_ElimTodos]
@RucE nvarchar(11),
    @Cd_ConceptoRet char(10)
As
Delete ConceptoRetencionDetProd
Where RucE = @RucE And Cd_ConceptoRet = @Cd_ConceptoRet
GO

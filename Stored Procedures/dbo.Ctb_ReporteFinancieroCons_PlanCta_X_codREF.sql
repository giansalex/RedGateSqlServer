SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroCons_PlanCta_X_codREF]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),

@msj varchar(100) output		

AS

Declare @Sql varchar(1000)
Set @Sql= 'Select '+@Cd_REF+' From PlanCtas Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and isnull('+@Cd_REF+','''')<>'''''

Print @Sql
Exec(@Sql)

-- Leyenda --
-- DI : 12/10/2012 <Creacion del SP>

GO

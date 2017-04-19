SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinanciero_updatePlanCta]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Cd_REF nvarchar(5),
@Cd_Rub nvarchar(5),

@msj varchar(100) output

AS

if exists (Select * From PlanCtas Where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
Begin

	Declare @Sql varchar(8000)

	Set @Sql=
	'
	Update PlanCtas Set
		'+@Cd_REF+'='''+@Cd_Rub+'''
	Where 
		RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
	'

	Print @Sql
	Exec(@Sql)
End

-- Leyenda --
-- DI : 12/10/2012 <Creacion del SP>

GO

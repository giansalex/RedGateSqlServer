SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_CtasXPresupFCCons]

@RucE nvarchar(11),
@Ejer varchar(4),
@_CadenaCta varchar(1000),
@msj varchar(100) output
as

Declare @Cond1 nvarchar(2000)
Set @Cond1 = ''
if (ltrim(@_CadenaCta) <> '')
	Set @Cond1 = ' and NroCta not in ('+@_CadenaCta+')'
	

DECLARE @SQL nvarchar(4000)

SET @SQL = 'select NroCta,NomCta from PlanCtas where RucE='''+@RucE+''' and IB_PFC=1 and Nivel=4 and Ejer='''+@Ejer+''''+@Cond1+' Order by 1'

print @SQL
Exec (@SQL)


GO

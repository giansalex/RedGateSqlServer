SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasDefConsUn]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists (select * from PlanCtasDef where RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Esta empresa no contiene definicion de plan de cuentas'
else	select * from PlanCtasDef where RucE=@RucE and Ejer=@Ejer
print @msj
----------------------PRUEBA------------------------
--exec Ctb_PlanCtasDefConsUn '11111111111','2009',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- FL: 17/09/2010 <se agrego ejercicio>
GO

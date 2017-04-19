SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasConsUn]

@RucE nvarchar(11),
@Ejer varchar(4),
@NroCta nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Cuenta contable no existe'
else	select * from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer
print @msj

----------------------PRUEBA------------------------
--exec Ctb_PlanCtasConsUn '11111111111','2009','16.1.0.06',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- FL: 17/09/2010 <se agrego ejercicio>
GO

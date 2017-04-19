SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Cfg_PlanCtas_CfgIE]

@RucE nvarchar(11),
@Ejer varchar(4)
as
--Naturaleza

update PlanCtas Set IC_IEN='I' where RucE=@RucE and left(NroCta,1) = '7' and left(NroCta,2) not in ('79','74') and Ejer=@Ejer
update PlanCtas Set IC_IEN='E' where RucE=@RucE and  (left(NroCta,1) = '6' or left(NroCta,2) in ('74')) and Ejer=@Ejer


--Funcion 
update PlanCtas Set IC_IEF='I' where RucE=@RucE and left(NroCta,1) = '7' and left(NroCta,2) not in ('79','74') and Ejer=@Ejer
update PlanCtas Set IC_IEF='E' where RucE=@RucE and  (left(NroCta,1) = '6' or left(NroCta,2) in ('74')) and Ejer=@Ejer



----------------------PRUEBA------------------------
--exec Cfg_PlanCtas_CfgIE '11111111111','2009'

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>

GO

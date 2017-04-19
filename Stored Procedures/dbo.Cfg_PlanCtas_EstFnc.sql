SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Cfg_PlanCtas_EstFnc]
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

update PlanCtas set Cd_EGPF=NULL where RucE=@RucE and Ejer=@Ejer

update PlanCtas set Cd_EGPF='IF01' where RucE=@RucE and left(NroCta,2) in ('70','73') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (70-73)'
update PlanCtas set Cd_EGPF='EF01' where RucE=@RucE and left(NroCta,2) in ('69') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (69)'
update PlanCtas set Cd_EGPF='EF02' where RucE=@RucE and left(NroCta,2) in ('94') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (94)'
update PlanCtas set Cd_EGPF='EF03' where RucE=@RucE and left(NroCta,2) in ('95') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (95)'
update PlanCtas set Cd_EGPF='IF02' where RucE=@RucE and left(NroCta,2) in ('76') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (76)'
update PlanCtas set Cd_EGPF='IF03' where RucE=@RucE and left(NroCta,2) in ('77') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (77)'
update PlanCtas set Cd_EGPF='EF04' where RucE=@RucE and left(NroCta,2) in ('97') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (97)'
update PlanCtas set Cd_EGPF='EF05' where RucE=@RucE and left(NroCta,2) in ('66') and Ejer=@Ejer
	if @@rowcount <=0	set @msj = 'Error al modificar definicion de estados financieros (66)'

----------------------PRUEBA------------------------
--exec Cfg_PlanCtas_EstFnc '11111111111','2009',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>

GO

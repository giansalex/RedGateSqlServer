SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Help_PlanCtas_Elim]

@RucE nvarchar(11),
@Ejer nvarchar(4)

As

Declare @msj varchar(8000)
Set @msj = ''

delete from PlanCtas Where RucE=@RucE and Ejer=@Ejer
if @@rowcount < 0
	Set @msj += char(13)+'No se pudo eliminar Plan de Cuentas <Tabla PlanCtas>'
else
	Set @msj += char(13)+'Se elimino correctamente Plan de Cuentas <Tabla PlanCtas>'
	
delete from PlanCtasDef Where RucE=@RucE and Ejer=@Ejer
if @@rowcount < 0
	Set @msj += char(13)+'No se pudo eliminar Definicion de Plan de Cuentas <Tabla PlanCtasDef>'
else
	Set @msj += char(13)+'Se elimino correctamente Definicion de Plan de Cuentas <Tabla PlanCtasDef>'
	
delete from AmarreCta Where RucE=@RucE and Ejer=@Ejer
if @@rowcount < 0
	Set @msj += char(13)+'No se pudo eliminar Cuentas Destino <Tabla AmarreCta>'
else
	Set @msj += char(13)+'Se elimino correctamente Cuentas Destino <Tabla AmarreCta>'
	
	
print @msj

-- Leyenda --
-- DI <22/01/2013> : Creacion del SP

GO

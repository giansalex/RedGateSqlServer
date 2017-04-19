SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_CotizacionCons_Numero]

-- Este procedimiento nos devolvera el codigo o numero de la ultima cotizacion ingresada con el fin de imprimir o eliminar el ultimo ingreso

@RucE nvarchar(11),
@NroCot varchar(20) output,
@msj varchar(100) output

As

Set @NroCot = (Select top 1 r.NroCot from (Select TOP 1 Max(RucE) As RucE,Max(Cd_Cot) As Cd_Cot from Cotizacion Where RucE=@RucE) Tab
			Inner join Cotizacion r On r.RucE=Tab.RucE and r.Cd_Cot=Tab.Cd_Cot)

-- Leyenda --
-- DI : 22/02/2011 <Creacion del procedimiento almacenado>


GO

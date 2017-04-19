SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_CotizacionCons_Codigo]

-- Este procedimiento nos devolvera el codigo o numero de la ultima cotizacion ingresada con el fin de imprimir o eliminar el ultimo ingreso

@RucE nvarchar(11),
@NroCot varchar(20),
@Cd_Cot varchar(20) output,
@msj varchar(100) output

As

Set @Cd_Cot = (Select TOP 1 Max(Cd_Cot) As Cd_Cot from Cotizacion Where RucE=@RucE and NroCot=@NroCot)

-- Leyenda --
-- DI : 22/02/2011 <Creacion del procedimiento almacenado>
GO

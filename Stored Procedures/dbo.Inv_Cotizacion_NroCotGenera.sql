SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Cotizacion_NroCotGenera]
@RucE nvarchar(11),
@NroCot nvarchar(15) output,
@msj varchar(100) output

as

select @NroCot = user123.Nro_Cot(@RucE)

-- Leyenda --
-- DI : 23/04/2010 <Creacion del procedimiento>

GO

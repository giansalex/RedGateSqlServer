SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Venta_Cd_VtaGenera]
@RucE nvarchar(11),
@Cd_Vta char(10) output,
@msj varchar(100) output

as

select @Cd_Vta = user123.Cod_Vta(@RucE)
print @Cd_Vta
-- Leyenda --
-- JU : 2010-08-26 : <Creacion del procedimiento almacenado>
GO

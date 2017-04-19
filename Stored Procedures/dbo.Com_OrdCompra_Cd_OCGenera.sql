SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_Cd_OCGenera]
@RucE nvarchar(11),
@Cd_OC char(10) output,
@msj varchar(100) output

as

select @Cd_OC = dbo.Cd_OC(@RucE)
print @Cd_OC
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>

GO

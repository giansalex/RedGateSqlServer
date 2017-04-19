SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Compra_Cd_ComGenera]
@RucE nvarchar(11),
@Cd_Com char(10) output,
@msj varchar(100) output

as

select @Cd_Com = dbo.Cd_Com(@RucE)
print @Cd_Com
-- Leyenda --
-- JU : 2010-08-26 : <Creacion del procedimiento almacenado>

GO

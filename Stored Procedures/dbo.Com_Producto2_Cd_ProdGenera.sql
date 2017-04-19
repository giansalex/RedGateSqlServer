SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Producto2_Cd_ProdGenera]
@RucE nvarchar(11),
@Cd_Prod char(7) output,
@msj varchar(100) output
as
select @Cd_Prod = dbo.Cod_Prod2(@RucE)
print @Cd_Prod
-- Leyenda --
-- MP : 05-11-2010 : <Creacion del procedimiento almacenado>



GO

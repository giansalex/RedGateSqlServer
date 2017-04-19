SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_NroRegGenera]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@Prdo nvarchar(2), 
@Cd_MR nvarchar(2),
@Cd_Area nvarchar(6),
@RegCtb nvarchar(15) output, 
@msj varchar(100) output
as

set @RegCtb = dbo.RegCtb_Com(@RucE, @Cd_MR, @Cd_Area, @Ejer, @Prdo )
print @RegCtb
if @RegCtb = '' or @RegCtb is null
   set @msj = 'No se pudo generar Nro de Registro Contable'
-- Leyenda --
-- JU : 2010-08-19 : <Creacion del procedimiento almacenado>


GO

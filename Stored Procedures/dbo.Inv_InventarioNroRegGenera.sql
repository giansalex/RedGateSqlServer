SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioNroRegGenera]
@RucE nvarchar(11),
@RegCtb nvarchar(15) output, 
@Ejer nvarchar(4), 
@FecMov smalldatetime, 
@Cd_Area nvarchar(6),
@msj varchar(100) output
as

set @RegCtb =  dbo.RegCtb_Inv(@RucE, @Cd_Area, @Ejer,  right('00'+convert(nvarchar,month(@FecMov)), 2) )
if @RegCtb = '' or @RegCtb is null
   set @msj = 'No se pudo generar Nro de Regsitro Contable'

-- Execute --
--declare @s nvarchar(15)
--exec Inv_InventarioNroRegGenera '11111111111','010101','2010', '24/06/2010', @s out, null
--print @s

-- Leyenda --
-- PP : 2010-07-19 11:33:48.227	: <Creacion del procedimiento almacenado>
GO
